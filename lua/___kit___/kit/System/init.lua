-- luacheck: ignore 212

local kit = require('___kit___.kit')
local Async = require('___kit___.kit.Async')

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
function System.LineBuffering:create(callback)
  local buffer = {}
  return {
    write = function(data)
      data = (data:gsub('\r\n?', '\n'))
      table.insert(buffer, data)

      local has = false
      for i = #data, 1, -1 do
        if data:sub(i, i) == '\n' then
          has = true
          break
        end
      end

      if has then
        local texts = vim.split(table.concat(buffer, ''), '\n')
        buffer = texts[#texts] ~= '' and { table.remove(texts) } or {}
        for _, text in ipairs(texts) do
          if self.ignore_empty then
            if text:gsub('^%s*', ''):gsub('%s*$', '') ~= '' then
              callback(text)
            end
          else
            callback(text)
          end
        end
      end
    end,
    close = function()
      if #buffer > 0 then
        callback(table.concat(buffer, ''))
      end
    end
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
  local buffer = {}
  local state = {
    delimiter_pos = 1,
    curr_buffer_pos = { 1, 1 },
  }

  local function next_pos(start_i, start_j)
    if not buffer[start_i] then
      return start_i, start_j
    end
    if start_j >= #buffer[start_i] then
      return start_i + 1, 1
    end
    return start_i, start_j + 1
  end

  local function is_ended(i, j)
    local is_not_ended = i < #buffer or (i == #buffer and j < #buffer[i])
    return not is_not_ended
  end

  local function buf_chars(start_i, start_j)
    return function()
      if start_i <= #buffer then
        if start_j <= #buffer[start_i] then
          local current_i, current_j = start_i, start_j
          start_i, start_j = next_pos(start_i, start_j)
          return buffer[current_i]:sub(current_j, current_j), current_i, current_j
        end
      end
    end
  end
  return {
    write = function(data)
      table.insert(buffer, data)

      while not is_ended(state.curr_buffer_pos[1], state.curr_buffer_pos[2]) do
        local match_start_pos = nil --[[@as { [1]: integer, [2]: integer }|nil]]
        for char, i, j in buf_chars(state.curr_buffer_pos[1], state.curr_buffer_pos[2]) do
          if char == self.delimiter:sub(state.delimiter_pos, state.delimiter_pos) then
            if state.delimiter_pos == 1 then
              match_start_pos = { i, j }
            end

            if state.delimiter_pos == #self.delimiter and match_start_pos then
              local texts = {}
              for k = 1, match_start_pos[1] do
                if k == match_start_pos[1] then
                  table.insert(texts, buffer[k]:sub(1, match_start_pos[2] - 1))
                else
                  table.insert(texts, buffer[k])
                end
              end
              callback(table.concat(texts, ''))

              if not is_ended(i, j) then
                local next_buffer = {}
                for k = i, #buffer do
                  if k == i then
                    table.insert(next_buffer, buffer[k]:sub(j + 1))
                  else
                    table.insert(next_buffer, buffer[k])
                  end
                end
                buffer = next_buffer
              else
                buffer = {}
              end
              state.delimiter_pos = 1
              state.curr_buffer_pos = { 1, 1 }
              break
            end
            state.delimiter_pos = state.delimiter_pos + 1
          else
            state.delimiter_pos = 1
            state.curr_buffer_pos = (match_start_pos and { next_pos(match_start_pos[1], match_start_pos[2]) } or { next_pos(i, j) })
          end
        end
      end
    end,
    close = function()
      if #buffer > 0 then
        callback(table.concat(buffer, ''))
      end
    end
  }
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
    end
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

  local env = params.env
  if not env then
    env = vim.fn.environ()
    env.NVIM = vim.v.servername
    env.NVIM_LISTEN_ADDRESS = nil
  end

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
    gid = vim.uv.getgid(),
    uid = vim.uv.getuid(),
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
    table.insert(closing, Async.new(function(resolve)
      if not stdout:is_closing() then
        stdout:close(resolve)
      else
        resolve()
      end
    end))
    table.insert(closing, Async.new(function(resolve)
      if not stderr:is_closing() then
        stderr:close(resolve)
      else
        resolve()
      end
    end))
    table.insert(closing, Async.new(function(resolve)
      if signal and process:is_active() then
        process:kill(signal)
      end
      if process and not process:is_closing() then
        process:close(resolve)
      else
        resolve()
      end
    end))

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
