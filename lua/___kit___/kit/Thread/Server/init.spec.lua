local Server = require('___kit___.kit.Thread.Server')

describe('kit.Thread.Server', function()
  it('should work basic usage', function()
    local server = Server.new(function(session)
      function session.on_request.echo(params, callback)
        callback(params)
      end
    end)
    server:connect()
    local res = server:request('echo', {
      message = 'aiueo'
    }):sync()
    vim.pretty_print(res)
    vim.wait(500)
  end)
end)

