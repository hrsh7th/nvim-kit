local uv = require('luv')
local Session = require('___kit___.kit.Thread.Server.Session')

---@return string
local function get_script_path()
  return debug.getinfo(2, "S").source:sub(2):match("(.*)/")
end

local Server = {}
Server.__index = Server

function Server.new(dispatcher)
  local self = setmetatable({}, Server)
  self.dispatcher = dispatcher
  self.stdin = uv.new_pipe()
  self.stdout = uv.new_pipe()
  self.stderr = uv.new_pipe()
  self.process = uv.spawn('nvim', {
    cwd = uv.cwd(),
    args = { '-u', 'NONE', '--headless', '--noplugin', '-l', ('%s/Bootstrap.lua'):format(get_script_path()), vim.o.runtimepath },
    stdio = { self.stdin, self.stdout, self.stderr }
  })
  self.session = Session.new(self.stdout, self.stdin)
  self.session:request('initialize', {
    dispatcher = string.dump(self.dispatcher)
  }):sync()
  return self
end

---@param method string
---@param params table
function Server:request(method, params)
  return self.session:request(method, params)
end

---@param method string
---@param params table
function Server:notify(method, params)
  self.session:notify(method, params)
end

function Server:kill()
  uv.kill(self.process)
end

return Server
