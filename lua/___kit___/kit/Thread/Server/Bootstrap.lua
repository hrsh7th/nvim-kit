_G.f = io.open('/Users/hiroshi_shichita/Develop/hoge.txt', 'w')
assert(f)

vim.o.runtimepath = _G.arg[1]

local uv = require('luv')
local Session = require('___kit___.kit.Thread.Server.Session')

local stdin = uv.new_pipe()
stdin:open(0)
local stdout = uv.new_pipe()
stdout:open(1)
local session = Session.new(stdin, stdout)
function session.on_request.initialize(params)
  loadstring(params.dispatcher)(session)
end

while true do
  uv.run('once')
  f:flush()
end
