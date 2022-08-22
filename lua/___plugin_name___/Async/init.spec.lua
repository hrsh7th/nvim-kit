local Async = require('___plugin_name___.Async')

local async = Async.async
local await = Async.await

describe('kit.Async', function()

  local throw_error = function()
    return Async.async(function()
      error('throw_error')
    end)
  end

  local return_error = function()
    return async(function(callback)
      vim.schedule(function()
        callback('return_error')
      end)
    end)
  end

  local return_value = function()
    return async(function(callback)
      vim.schedule(function()
        callback(nil, 'return_value')
      end)
    end)
  end

  it('should work with multiple async task', function()
    local text = Async.run(function()
      return await(return_value()) .. ':' .. await(return_value())
    end):sync()
    assert.equal(text, 'return_value:return_value')
  end)

  it('should work with return error', function()
    local _, err = pcall(function()
      return Async.run(function()
        await(return_value())
        await(return_error())
        return Async.await(return_value())
      end):sync()
    end)
    assert.are_not.is_nil(string.match(err, 'return_error$'))
  end)

  it('should work with throw error', function()
    local _, err = pcall(function()
      return Async.run(function()
        await(return_value())
        await(throw_error())
        return Async.await(return_value())
      end):sync()
    end)
    assert.are_not.is_nil(string.match(err, 'throw_error$'))
  end)

  it('should work with cancel', function()
    local progress = Async.run(function()
      return Async.await(return_value())
    end)
    progress(function()
      assert.equal(true, false) -- do not call.
    end)
    progress:cancel()

    local _, err = pcall(function()
      return progress:sync()
    end)
    assert.are_not.is_nil(string.match(err, Async.CancelError .. '$'))
  end)

end)

