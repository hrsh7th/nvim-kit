local mpack = require('mpack')
local kit = require('___kit___.kit')
local Async = require('___kit___.kit.Async')

local function log(...)
  if _G.f then
    _G.f:write('[server]\t')
    _G.f:flush()
  else
    io.write('[client]\t')
    io.flush()
  end
  for _, v in ipairs({ ... }) do
    if _G.f then
      _G.f:write(vim.inspect(v) .. '\t')
      _G.f:flush()
    else
      io.write(vim.inspect(v) .. '\t')
      io.flush()
    end
  end
  if _G.f then
    _G.f:write('\n')
    _G.f:flush()
  else
    io.write('\n')
    io.flush()
  end
end

local function serialize(tbl)
  return kit.convert(tbl, function(v)
    if v == nil then
      return mpack.NIL
    else
      return v
    end
  end)
end

local Session = {}
Session.__index = Session

function Session.new(reader, writer)
  local self = setmetatable({}, Session)
  self.reader = reader
  self.writer = writer
  self.session = mpack.Session({
    unpack = mpack.Unpacker()
  })
  self.on_request = {}
  self.on_notification = {}
  Async.on_unhandled_rejection = function(err)
    log('on_unhandled_rejection', err)
  end
  self.reader:read_start(function(err, data)
    local ok, err = pcall(function()
      if err then
        log('read error: ', err)
        error(err)
      end
      if not data then
        return
      end

      local offset = 1
      local length = #data
      local type, id_or_cb, method_or_error, params_or_result
      while offset <= length do
        type, id_or_cb, method_or_error, params_or_result, offset = self.session:receive(data, offset)
        if type == 'request' then
          local request_id, method, params = id_or_cb, method_or_error, params_or_result
          log('<-', 'request', method, params)
          Async.resolve():next(function()
            return Async.run(function()
              return self.on_request[method](params)
            end)
          end):next(function(res)
            log('->', 'response(res)', res)
            self:_write(self.session:reply(request_id) .. mpack.encode(mpack.NIL) .. mpack.encode(serialize(res)))
          end):catch(function(err)
            log('->', 'response(err)', err)
            self:_write(self.session:reply(request_id) .. mpack.encode(serialize(err)) .. mpack.encode(mpack.NIL))
          end)
        elseif type == 'notification' then
          local method, params = method_or_error, params_or_result
          log('<-', 'notification', method, params)
          self.on_notification[method](params)
        elseif type == 'response' then
          local callback, err, res = id_or_cb, method_or_error, params_or_result
          log('<-', 'response', callback, err, res)
          if err == mpack.NIL then
            err = nil
          else
            res = nil
          end
          callback(err, res)
        end
      end
    end)
    if not ok then
      log('error', err)
    end
  end)
  return self
end

function Session:request(method, params)
  return Async.new(function(resolve, reject)
    local request = self.session:request(function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    self:_write(request .. mpack.encode(method) .. mpack.encode(serialize(params)))
  end)
end

function Session:notify(method, params)
  self:_write(self.session:notify() .. mpack.encode(method) .. mpack.encode(serialize(params)))
end

function Session:_write(data)
  self.writer:write(data, function(err)
    if err then
      log('write error', err)
    end
  end)
end

return Session
