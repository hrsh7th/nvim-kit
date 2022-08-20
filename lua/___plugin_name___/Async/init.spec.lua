local Async = require('___plugin_name___.Async')
local Promise = require('___plugin_name___.Async.Promise')

describe('kit.Async', function()

  it('should behave like as JavaScript async-await', function()
    local echo_async = Async.async(function(text)
      local text1 = Async.await(Promise.new(function(resolve)
        vim.defer_fn(function()
          resolve(text .. text)
        end, 100)
      end))
      local text2 = Async.await(Promise.new(function(resolve)
        vim.defer_fn(function()
          resolve(text1 .. text1)
        end, 100)
      end))
      return text2
    end)

    Promise.wait(Async.async(function()
      local text = Async.await(echo_async('hello'))
      assert.equal(text, 'hellohellohellohello')
    end)())
  end)

end)

