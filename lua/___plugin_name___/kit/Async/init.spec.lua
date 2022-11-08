local Async = require('___plugin_name___.kit.Async')
local AsyncTask = require('___plugin_name___.kit.Async.AsyncTask')

local async = Async.async
local await = Async.await

describe('kit.Async', function()
  local multiply = async(function(v)
    return AsyncTask.new(function(resolve)
      vim.schedule(function()
        resolve(v * v)
      end)
    end)
  end)
  it('should work like JavaScript Promise', function()
    local num = async(function()
      local num = 2
      num = await(multiply(num))
      num = await(multiply(num))
      return num
    end)():sync()
    assert.are.equal(num, 16)
  end)
  it('should work with exception', function()
    pcall(function()
      Async.run(function()
        error('error')
      end):sync()
    end)
  end)
end)
