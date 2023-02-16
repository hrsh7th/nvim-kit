local AsyncTask = require('___kit___.kit.Async.AsyncTask')

describe('kit.Async', function()
  local once = function(fn)
    local done = false
    return function(...)
      if done then
        error('already called')
      end
      done = true
      return fn(...)
    end
  end

  it('should work AsyncTask:{next/catch}', function()
    -- first.
    local one_task = AsyncTask.new(once(function(resolve)
      vim.schedule(function()
        resolve(1)
      end)
    end))
    assert.are.equals(one_task:sync(), 1)

    -- next with return value.
    local two_task = one_task:next(once(function(value)
      return value + 1
    end))
    assert.are.equals(two_task:sync(), 2)

    -- next with return AsyncTask.
    local three_task = two_task:next(once(function(value)
      return AsyncTask.new(function(resolve)
        vim.schedule(function()
          resolve(value + 1)
        end)
      end)
    end))
    assert.are.equals(three_task:sync(), 3)

    -- throw error.
    local err_task = three_task:next(once(function()
      error('error')
    end))
    local _, err = pcall(function()
      return err_task:sync()
    end)
    assert.are_not.equals(string.match(err, 'error$'), nil)

    -- skip rejected task's next.
    local steps = {}
    local catch_task = err_task
        :next(once(function()
          table.insert(steps, 1)
        end))
        :next(once(function()
          table.insert(steps, 2)
        end))
        :catch(function()
          return 'catch'
        end)
        :next(function(value)
          table.insert(steps, 3)
          return value
        end)
    assert.are.same(steps, { 3 })
    assert.are.equals(catch_task:sync(), 'catch')
  end)

  it('should reject if resolve called with rejected task', function()
    local task = AsyncTask.new(function(_, reject)
      vim.defer_fn(reject, 10)
    end)
    local ok
    ok = pcall(function()
      AsyncTask.resolve(task):sync()
    end)
    assert.is_false(ok)
    ok = pcall(function()
      AsyncTask.resolve(task):sync()
    end)
    assert.is_false(ok)
  end)

  it('should throw timeout error', function()
    local task = AsyncTask.new(function(resolve)
      vim.defer_fn(resolve, 500)
    end)
    local ok = pcall(function()
      return task:sync(100)
    end)
    assert.is_false(ok)
  end)

  it('should work AsyncTask.all', function()
    local now = vim.loop.now()
    local values = AsyncTask.all({
          AsyncTask.new(function(resolve)
            vim.defer_fn(function()
              resolve(1)
            end, 300)
          end),
          AsyncTask.new(function(resolve)
            vim.defer_fn(function()
              resolve(2)
            end, 200)
          end),
          AsyncTask.new(function(resolve)
            vim.defer_fn(function()
              resolve(3)
            end, 100)
          end),
        }):sync()
    assert.are.same(values, { 1, 2, 3 })
    assert.is_true((vim.loop.now() - now) - 300 < 10)
  end)

  it('should work AsyncTask.race', function()
    local now = vim.loop.now()
    local value = AsyncTask.race({
          AsyncTask.new(function(resolve)
            vim.defer_fn(function()
              resolve(1)
            end, 300)
          end),
          AsyncTask.new(function(resolve)
            vim.defer_fn(function()
              resolve(2)
            end, 200)
          end),
          AsyncTask.new(function(resolve)
            vim.defer_fn(function()
              resolve(3)
            end, 100)
          end),
        }):sync()
    assert.are.same(value, 3)
    assert.is_true((vim.loop.now() - now) - 100 < 10)
  end)

  it('should return current state of task', function()
    local success = AsyncTask.new(function(resolve)
      vim.defer_fn(function()
        resolve(1)
      end, 100)
    end)
    assert.are.same(success:state(), { status = AsyncTask.Status.Pending })
    success:sync()
    assert.are.same(success:state(), { status = AsyncTask.Status.Fulfilled, value = 1 })

    local failure = AsyncTask.new(function(_, reject)
      vim.defer_fn(function()
        reject(1)
      end, 100)
    end)
    assert.are.same(failure:state(), { status = AsyncTask.Status.Pending })
    pcall(function()
      failure:sync()
    end)
    assert.are.same(failure:state(), { status = AsyncTask.Status.Rejected, value = 1 })
  end)

  it('should work AsyncTask.on_unhandled_rejection', function()
    local called = false

    ---@diagnostic disable-next-line: duplicate-set-field
    function AsyncTask.on_unhandled_rejection()
      called = true
    end

    -- has no catched.
    AsyncTask.new(function()
      error('error')
    end)
    called = false
    vim.wait(1)
    assert.are.equals(called, true)

    -- has no catched.
    AsyncTask.new(function()
      error('error')
    end):next(function()
      -- ignore
    end)
    called = false
    vim.wait(1)
    assert.are.equals(called, true)

    -- has no catched.
    AsyncTask.new(function(resolve)
      resolve(nil)
    end):next(function()
      error('error')
    end)
    called = false
    vim.wait(1)
    assert.are.equals(called, true)

    -- has no catched.
    AsyncTask.new(function(_, reject)
      reject('error')
    end):catch(function(err)
      error(err)
    end)
    called = false
    vim.wait(1)
    assert.are.equals(called, true)

    -- catched.
    AsyncTask.new(function()
      error('error')
    end):catch(function()
      -- ignore
    end)
    called = false
    vim.wait(1)
    assert.are.equals(called, false)

    -- has no catched task but synced.
    local task = AsyncTask.new(function()
      error('error')
    end)
    pcall(function()
      task:sync()
    end)
    called = false
    vim.wait(1)
    assert.are.equals(called, false)
  end)
end)
