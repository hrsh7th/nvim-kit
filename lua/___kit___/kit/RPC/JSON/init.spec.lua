local RPC = require('___kit___.kit.RPC.JSON')
local Async = require('___kit___.kit.Async')

describe('kit.RPC.JSON', function()
  local function create_pair()
    local fds_a = assert(vim.uv.socketpair(nil, nil, { nonblock = true }, { nonblock = true }))
    local fd_a1 = assert(vim.uv.new_tcp())
    fd_a1:open(fds_a[1])
    local fd_a2 = assert(vim.uv.new_tcp())
    fd_a2:open(fds_a[2])

    local fds_b = assert(vim.uv.socketpair(nil, nil, { nonblock = true }, { nonblock = true }))
    local fd_b1 = assert(vim.uv.new_tcp())
    fd_b1:open(fds_b[1])
    local fd_b2 = assert(vim.uv.new_tcp())
    fd_b2:open(fds_b[2])

    local a = RPC.new({ transport = RPC.Transport.LineDelimitedPipe.new(fd_a1, fd_b2) })
    a:start()
    local b = RPC.new({ transport = RPC.Transport.LineDelimitedPipe.new(fd_b1, fd_a2) })
    b:start()
    return a, b
  end

  it('should work with request', function()
    local a, b = create_pair()
    b:on_request('sum', function(ctx)
      return ctx.params.a + ctx.params.b
    end)

    assert.are.equal(
      a:request('sum', {
        a = 1,
        b = 2,
      }):sync(200),
      3
    )
  end)

  it('should work with notification', function()
    local a, b = create_pair()

    Async.new(function(resolve)
      b:on_notification('notification', resolve)
      a:notify('notification', {})
    end):sync(200)
  end)
end)
