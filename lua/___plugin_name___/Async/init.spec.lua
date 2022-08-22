local Async = require('___plugin_name___.Async')

describe('kit.Async', function()

  local throw_error = function()
    return Async.async(function()
      error('throw_error')
    end)
  end

  local return_error = function()
    return Async.async(function(callback)
      vim.schedule(function()
        callback('return_error')
      end)
    end)
  end

  local return_value = function(value)
    return Async.async(function(callback)
      vim.schedule(function()
        callback(nil, value)
      end)
    end)
  end

  it('should work with twice async', function()
    local text = Async.run(function()
      local text1 = Async.await(return_value('hello'))
      local text2 = Async.await(return_value(text1 .. text1))
      return text2
    end):sync()
    assert.equal(text, 'hellohello')
  end)

  it('should work with error value', function()
    local _, err = pcall(function()
      return Async.run(function()
        Async.await(return_value())
        Async.await(return_error())
        return Async.await(return_value())
      end):sync()
    end)
    assert.are_not.is_nil(string.match(err, 'return_error$'))
  end)

  it('should work with throw error', function()
    local _, err = pcall(function()
      return Async.run(function()
        Async.await(return_value())
        Async.await(throw_error())
        return Async.await(return_value())
      end):sync()
    end)
    assert.are_not.is_nil(string.match(err, 'throw_error$'))
  end)

end)

