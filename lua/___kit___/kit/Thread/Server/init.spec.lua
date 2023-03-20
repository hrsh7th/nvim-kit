local Server = require('___kit___.kit.Thread.Server')

describe('kit.Thread.Server', function()
  it('should work basic usage', function()
    local server = Server.new(function(session)
      session:on_request('error', function()
        error('error')
      end)

      session:on_request('ping', function(params)
        return params
      end)

      session:on_notification('ping', function(params)
        session:notify('pong', params)
      end)
    end)
    server:connect():sync()

    -- request `error` method.
    do
      local ok = pcall(function()
        server:request('error', {}):sync()
      end)
      assert.are.same(false, ok)
    end

    -- request `ping`.
    do
      local pong = server:request('ping', { message = 'aiueo' }):sync()
      assert.are.same({ message = 'aiueo' }, pong)
    end

    -- notify `ping`.
    do
      local pong = nil
      server:on_notification('pong', function(params)
        pong = params
      end)
      server:notify('ping', { message = 'aiueo' })

      vim.wait(500, function()
        return pong
      end)
      assert.are.same({ message = 'aiueo' }, pong)
    end

    server:kill()
  end)
end)
