local Async = require('___kit___.kit.Async')
local AsyncTask = require('___kit___.kit.Async.AsyncTask')

describe('kit.Async', function()
  local multiply = function(v)
    return AsyncTask.new(function(resolve)
      vim.schedule(function()
        resolve(v * v)
      end)
    end)
  end

  it('should detect async context', function()
    assert.are.equal(Async.in_context(), false)
    Async.run(function()
      assert.are.equal(Async.in_context(), true)
    end)
  end)

  it('should work like JavaScript Promise', function()
    local num = Async.run(function()
      local num = 2
      num = multiply(num):await()
      num = multiply(num):await()
      return num
    end):sync(5000)
    assert.are.equal(num, 16)
  end)

  it('should work with exception', function()
    pcall(function()
      Async.run(function()
        error('error')
      end):sync(5000)
    end)
  end)

  it('should work with exception (nested)', function()
    Async.run(function()
      return Async.run(function()
        Async.run(function()
          error('error')
        end):await()
        assert.is_true(false) -- should not reach here.
      end):catch(function()
        assert.is_true(true)
      end)
    end):sync(5000)
  end)

  describe('.promisify', function()
    it('shoud wrap callback function', function()
      local function wait(ms, callback)
        vim.defer_fn(function()
          callback(nil, 'timeout')
        end, ms)
      end

      local wait_async = Async.promisify(wait)
      assert.equals(wait_async(100):sync(5000), 'timeout')
    end)
    it('shoud wrap callback function with rest arguments', function()
      local function wait(ms, callback, result)
        vim.defer_fn(function()
          callback(nil, result)
        end, ms)
      end

      local wait_async = Async.promisify(wait, { callback = 2 })
      assert.equals(wait_async(100, 'timeout'):sync(5000), 'timeout')
    end)
  end)
end)
