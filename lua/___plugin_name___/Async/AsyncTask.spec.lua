local AsyncTask = require('___plugin_name___.Async.AsyncTask')

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

  it('should work like JavaScript Promise', function()
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
    local catch_task = err_task:next(once(function()
      table.insert(steps, 1)
    end)):next(once(function()
      table.insert(steps, 2)
    end)):catch(function()
      return 'catch'
    end):next(function(value)
      table.insert(steps, 3)
      return value
    end)
    assert.are.same(steps, { 3 })
    assert.are.equals(catch_task:sync(), 'catch')
  end)

end)

