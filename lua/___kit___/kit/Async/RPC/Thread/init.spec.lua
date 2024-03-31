local Thread = require('___kit___.kit.Async.RPC.Thread')

describe('kit.Async.RPC.Thread', function()
  it('should work', function()
    local thread = Thread.new(function(session)
      session:on_request('run', function(params)
        return params.runner(unpack(params.params))
      end)
    end)

    -- mul
    assert.are.equal(thread:request('run', {
      params = { 2, 3 },
      runner = function(a, b)
        return a * b
      end
    }):sync(), 6)

    -- sum
    assert.are.equal(thread:request('run', {
      params = { 2, 3 },
      runner = function(a, b)
        return a + b
      end
    }):sync(), 5)

    thread:close():sync()
  end)
end)
