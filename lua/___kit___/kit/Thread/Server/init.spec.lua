local Server = require('___kit___.kit.Thread.Server')

describe('kit.Thread.Server', function()
  local function assert_server(server)
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
  end

  it('should work basic usage', function()
    print('run basic')
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
    assert_server(server)
    server:kill()
  end)

  it('should work nested server', function()
    print('run nested')
    local root_server = Server.new(function(root_session)
      local nested_server = require('___kit___.kit.Thread.Server').new(function(nested_session)
        nested_session:on_request('error', function()
          error('error')
        end)
        nested_session:on_request('ping', function(params)
          return params
        end)
        nested_session:on_notification('ping', function(params)
          nested_session:notify('pong', params)
        end)
      end)
      nested_server:connect():await()

      root_session:on_request('error', function()
        return nested_server:request('error', {})
      end)
      root_session:on_request('ping', function(params)
        return nested_server:request('ping', params)
      end)
      root_session:on_notification('ping', function(params)
        nested_server:notify('ping', params)
      end)
      nested_server:on_notification('pong', function(params)
        root_session:notify('pong', params)
      end)
    end)
    root_server:connect():sync()
    assert_server(root_server)
    root_server:kill()
  end)
end)
