local Server = require('___kit___.kit.Thread.Server')

describe('kit.Thread.Server', function()
  it('should work basic usage', function()
    local server = Server.new(function(session)
      function session.on_request.res(params)
        return params
      end

      function session.on_request.err()
        error('error')
      end
    end)
    server:connect():sync()

    local res = server:request('res', { message = 'aiueo' }):sync()
    assert.are.same({ message = 'aiueo' }, res)

    local ok = pcall(function()
      server:request('err', { message = 'aiueo' }):sync()
    end)
    assert.are.same(false, ok)

    server:kill()
  end)
end)
