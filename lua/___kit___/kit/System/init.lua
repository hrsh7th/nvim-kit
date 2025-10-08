-- luacheck: ignore 212

local kit = require('___kit___.kit')
local Async = require('___kit___.kit.Async')

local bytes = {
  ['\n'] = 10,
  ['\r'] = 13,
}

local System = {}

---@class ___kit___.kit.System.Buffer
---@field write fun(data: string)
---@field close fun()

---@class ___kit___.kit.System.Buffering
---@field create fun(self: any, callback: fun(data: string)): ___kit___.kit.System.Buffer

---@class ___kit___.kit.System.LineBuffering: ___kit___.kit.System.Buffering
---@field ignore_empty boolean
System.LineBuffering = {}
System.LineBuffering.__index = System.LineBuffering

---Create LineBuffering.
---@param option { ignore_empty?: boolean }
function System.LineBuffering.new(option)
  return setmetatable({
    ignore_empty = option.ignore_empty or false,
  }, System.LineBuffering)
end

---Create LineBuffer object.
---@param callback fun(data: string)
function System.LineBuffering:create(callback)
  local callback_wrapped = callback
  if self.ignore_empty then
    ---@param data string
    function callback_wrapped(data)
      if data ~= '' then
        return callback(data)
      end
    end
  end

  local buffer = kit.buffer()
  local iter = buffer.iter_bytes()
  ---@type ___kit___.kit.System.Buffer
  return {
    write = function(data)
      buffer.put(data)
      local found = true
      while found do
        found = false
        for i, byte in iter do
          if byte == bytes['\n'] then
            if buffer.peek(i - 1) == bytes['\r'] then
              callback_wrapped(buffer.get(i - 2))
              buffer.skip(2)
            else
              callback_wrapped(buffer.get(i - 1))
              buffer.skip(1)
            end
            iter = buffer.iter_bytes()
            found = true
            break
          end
        end
        if not found then
          break
        end
      end
    end,
    close = function()
      for byte, i in buffer.iter_bytes() do
        if byte == bytes['\n'] then
          if buffer.peek(i - 1) == bytes['\r'] then
            callback_wrapped(buffer.get(i - 2))
            buffer.skip(2)
          else
            callback_wrapped(buffer.get(i - 1))
            buffer.skip(1)
          end
        end
      end
      callback_wrapped(buffer.get())
    end,
  }
end

---@class ___kit___.kit.System.DelimiterBuffering: ___kit___.kit.System.Buffering
---@field delimiter string
System.DelimiterBuffering = {}
System.DelimiterBuffering.__index = System.DelimiterBuffering

---Create Buffering.
---@param option { delimiter: string }
function System.DelimiterBuffering.new(option)
  return setmetatable({
    delimiter = option.delimiter,
  }, System.DelimiterBuffering)
end

---Create Delimiter object.
function System.DelimiterBuffering:create(callback)
  local state = {
    buffer = {},
    buffer_pos = 1,
    delimiter_pos = 1,
    match_pos = nil --[[@as integer?]],
  }

  local function len()
    local l = 0
    for i = 1, #state.buffer do
      l = l + #state.buffer[i]
    end
    return l
  end

  local function split(s, e)
    local before = {}
    local after = {}
    local off = 0
    for i = 1, #state.buffer do
      local l = #state.buffer[i]
      local sep_s = s - off
      local sep_e = e - off
      local buf_s = 1
      local buf_e = l

      if buf_e < sep_s then
        table.insert(before, state.buffer[i])
      elseif sep_e < buf_s then
        table.insert(after, state.buffer[i])
      else
        if buf_s < sep_s then
          table.insert(before, state.buffer[i]:sub(buf_s, sep_s - 1))
        end
        if sep_e < buf_e then
          table.insert(after, state.buffer[i]:sub(sep_e + 1, buf_e))
        end
      end

      off = off + l
    end
    return before, after
  end

  local function get(at)
    local off = 0
    for i = 1, #state.buffer do
      local l = #state.buffer[i]
      if at <= off + l then
        local idx = at - off
        return state.buffer[i]:sub(idx, idx)
      end
      off = off + l
    end
    return nil
  end

  local buffer_len = 0
  local delimiter_len = #self.delimiter
  local buffer
  buffer = {
    write = function(data)
      table.insert(state.buffer, data)
      buffer_len = len()

      while state.buffer_pos <= buffer_len do
        local b = get(state.buffer_pos)
        local d = self.delimiter:sub(state.delimiter_pos, state.delimiter_pos)
        if b == d then
          if state.delimiter_pos == delimiter_len then
            local before, after = split(state.match_pos, state.buffer_pos)
            callback(table.concat(before, ''))
            state.buffer = after
            state.buffer_pos = 1
            state.delimiter_pos = 1
            state.match_pos = nil
            buffer_len = len()
          else
            if state.delimiter_pos == 1 then
              state.match_pos = state.buffer_pos
            end
            state.buffer_pos = state.buffer_pos + 1
            state.delimiter_pos = state.delimiter_pos + 1
          end
        else
          state.buffer_pos = state.match_pos and state.match_pos + 1 or state.buffer_pos + 1
          state.delimiter_pos = 1
          state.match_pos = nil
        end
      end
    end,
    close = function()
      if #state.buffer > 0 then
        callback(table.concat(state.buffer, ''))
      end
    end,
  }
  return buffer
end

---@class ___kit___.kit.System.RawBuffering: ___kit___.kit.System.Buffering
System.RawBuffering = {}
System.RawBuffering.__index = System.RawBuffering

---Create RawBuffering.
function System.RawBuffering.new()
  return setmetatable({}, System.RawBuffering)
end

---Create RawBuffer object.
function System.RawBuffering:create(callback)
  return {
    write = function(data)
      callback(data)
    end,
    close = function()
      -- noop.
    end,
  }
end

---Spawn a new process.
---@class ___kit___.kit.System.SpawnParams
---@field cwd string
---@field env? table<string, string>
---@field input? string|string[]
---@field on_stdout? fun(data: string)
---@field on_stderr? fun(data: string)
---@field on_exit? fun(code: integer, signal: integer)
---@field buffering? ___kit___.kit.System.Buffering
---@param command string[]
---@param params ___kit___.kit.System.SpawnParams
---@return fun(signal?: integer)
function System.spawn(command, params)
  command = vim
      .iter(command)
      :filter(function(c)
        return c ~= nil
      end)
      :totable()

  local cmd = command[1]
  local args = {}
  for i = 2, #command do
    table.insert(args, command[i])
  end

  local env = params.env or {}
  env = kit.merge(env, vim.fn.environ())
  env.NVIM = vim.v.servername
  env.NVIM_LISTEN_ADDRESS = nil

  local env_pairs = {}
  for k, v in pairs(env) do
    table.insert(env_pairs, string.format('%s=%s', k, tostring(v)))
  end

  local buffering = params.buffering or System.RawBuffering.new()
  local stdout_buffer = buffering:create(function(text)
    if params.on_stdout then
      params.on_stdout(text)
    end
  end)
  local stderr_buffer = buffering:create(function(text)
    if params.on_stderr then
      params.on_stderr(text)
    end
  end)

  local close --[[@type fun(signal?: integer): ___kit___.kit.Async.AsyncTask]]
  local stdin = params.input and assert(vim.uv.new_pipe())
  local stdout = assert(vim.uv.new_pipe())
  local stderr = assert(vim.uv.new_pipe())
  local process = vim.uv.spawn(vim.fn.exepath(cmd), {
    cwd = vim.fs.normalize(params.cwd),
    env = env_pairs,
    hide = true,
    args = args,
    stdio = { stdin, stdout, stderr },
    detached = false,
    verbatim = false,
  } --[[@as any]], function(code, signal)
    stdout_buffer.close()
    stderr_buffer.close()
    close():next(function()
      if params.on_exit then
        params.on_exit(code, signal)
      end
    end)
  end)
  stdout:read_start(function(err, data)
    if err then
      error(err)
    end
    if data then
      stdout_buffer.write(data)
    end
  end)
  stderr:read_start(function(err, data)
    if err then
      error(err)
    end
    if data then
      stderr_buffer.write(data)
    end
  end)

  local stdin_closing = Async.new(function(resolve)
    if stdin then
      for _, input in ipairs(kit.to_array(params.input)) do
        stdin:write(input)
      end
      stdin:shutdown(function()
        stdin:close(resolve)
      end)
    else
      resolve()
    end
  end)

  close = function(signal)
    local closing = { stdin_closing }
    table.insert(
      closing,
      Async.new(function(resolve)
        if not stdout:is_closing() then
          stdout:close(resolve)
        else
          resolve()
        end
      end)
    )
    table.insert(
      closing,
      Async.new(function(resolve)
        if not stderr:is_closing() then
          stderr:close(resolve)
        else
          resolve()
        end
      end)
    )
    table.insert(
      closing,
      Async.new(function(resolve)
        if signal and process:is_active() then
          process:kill(signal)
        end
        if process and not process:is_closing() then
          process:close(resolve)
        else
          resolve()
        end
      end)
    )

    local closing_task = Async.resolve()
    for _, task in ipairs(closing) do
      closing_task = closing_task:next(function()
        return task
      end)
    end
    return closing_task
  end

  return function(signal)
    close(signal)
  end
end

return System
