local uv = require('luv')
local Async = require('___plugin_name___.kit.Async')

local IO = {}

---@class ___plugin_name___.kit.IO.UV.Stat
---@field public dev integer
---@field public mode integer
---@field public nlink integer
---@field public uid integer
---@field public gid integer
---@field public rdev integer
---@field public ino integer
---@field public size integer
---@field public blksize integer
---@field public blocks integer
---@field public flags integer
---@field public gen integer
---@field public atime { sec: integer, nsec: integer }
---@field public mtime { sec: integer, nsec: integer }
---@field public ctime { sec: integer, nsec: integer }
---@field public birthtime { sec: integer, nsec: integer }
---@field public type string

---@enum ___plugin_name___.kit.IO.UV.AccessMode
IO.AccessMode = {
  r = 'r',
  rs = 'rs',
  sr = 'sr',
  ['r+'] = 'r+',
  ['rs+'] = 'rs+',
  ['sr+'] = 'sr+',
  w = 'w',
  wx = 'wx',
  xw = 'xw',
  ['w+'] = 'w+',
  ['wx+'] = 'wx+',
  ['xw+'] = 'xw+',
  a = 'a',
  ax = 'ax',
  xa = 'xa',
  ['a+'] = 'a+',
  ['ax+'] = 'ax+',
  ['xa+'] = 'xa+',
}

---@enum ___plugin_name___.kit.IO.WalkStatus
IO.WalkStatus = {
  SkipDir = 1,
}

---@type fun(path: string): ___plugin_name___.kit.Async.AsyncTask
IO.fs_stat = Async.promisify(uv.fs_stat)

---@type fun(path: string): ___plugin_name___.kit.Async.AsyncTask
IO.fs_unlink = Async.promisify(uv.fs_unlink)

---@type fun(path: string): ___plugin_name___.kit.Async.AsyncTask
IO.fs_rmdir = Async.promisify(uv.fs_rmdir)

---@type fun(path: string, mode: integer): ___plugin_name___.kit.Async.AsyncTask
IO.fs_mkdir = Async.promisify(uv.fs_mkdir)

---@type fun(from: string, to: string, option?: { excl?: boolean, ficlone?: boolean, ficlone_force?: boolean }): ___plugin_name___.kit.Async.AsyncTask
IO.fs_copyfile = Async.promisify(uv.fs_copyfile)

---@type fun(path: string, flags: ___plugin_name___.kit.IO.UV.AccessMode, mode: integer): ___plugin_name___.kit.Async.AsyncTask
IO.fs_open = Async.promisify(uv.fs_open)

---@type fun(fd: userdata): ___plugin_name___.kit.Async.AsyncTask
IO.fs_close = Async.promisify(uv.fs_close)

---@type fun(fd: userdata, chunk_size: integer, offset?: integer): ___plugin_name___.kit.Async.AsyncTask
IO.fs_read = Async.promisify(uv.fs_read)

---@type fun(fd: userdata, content: string, offset?: integer): ___plugin_name___.kit.Async.AsyncTask
IO.fs_write = Async.promisify(uv.fs_write)

---@type fun(fd: userdata, offset: integer): ___plugin_name___.kit.Async.AsyncTask
IO.fs_ftruncate = Async.promisify(uv.fs_ftruncate)

---@type fun(path: string): ___plugin_name___.kit.Async.AsyncTask
IO.fs_opendir = Async.promisify(uv.fs_opendir)

---@type fun(fd: userdata): ___plugin_name___.kit.Async.AsyncTask
IO.fs_closedir = Async.promisify(uv.fs_closedir)

---@type fun(fd: userdata): ___plugin_name___.kit.Async.AsyncTask
IO.fs_readdir = Async.promisify(uv.fs_readdir)

---Read file.
---@param path string
---@param chunk_size? integer
---@return ___plugin_name___.kit.Async.AsyncTask
function IO.read_file(path, chunk_size)
  chunk_size = chunk_size or 1024
  return Async.run(function()
    local stat = IO.fs_stat(path):await()
    local fd = IO.fs_open(path, IO.AccessMode.r, tonumber('755', 8)):await()
    local ok, res = pcall(function()
      local chunks = {}
      local offset = 0
      while offset < stat.size do
        local chunk = IO.fs_read(fd, math.min(chunk_size, stat.size - offset), offset):await()
        if not chunk then
          break
        end
        table.insert(chunks, chunk)
        offset = offset + #chunk
      end
      return table.concat(chunks, ''):sub(1, stat.size - 1) -- remove EOF.
    end)
    IO.fs_close(fd):await()
    if not ok then
      error(res)
    end
    return res
  end)
end

---Write file.
---@param path string
---@param content string
---@param chunk_size? integer
function IO.write_file(path, content, chunk_size)
  chunk_size = chunk_size or 1024
  content = content .. '\n' -- add EOF.
  return Async.run(function()
    local fd = IO.fs_open(path, IO.AccessMode.w, tonumber('755', 8)):await()
    local ok, err = pcall(function()
      local offset = 0
      while offset < #content do
        local chunk = content:sub(offset + 1, offset + chunk_size)
        offset = offset + IO.fs_write(fd, chunk, offset):await()
      end
      IO.fs_ftruncate(fd, offset):await()
    end)
    IO.fs_close(fd):await()
    if not ok then
      error(err)
    end
  end)
end

---Create directory.
---@param path string
---@param mode integer
---@param option? { recursive?: boolean }
function IO.mkdir(path, mode, option)
  path = IO.normalize(path)
  option = option or {}
  option.recursive = option.recursive or false
  return Async.run(function()
    if not option.recursive then
      IO.fs_mkdir(path, mode):await()
    else
      local not_exists = {}
      local current = path
      while current ~= '/' do
        local stat = IO.fs_stat(current):catch(function() end):await()
        if stat then
          break
        end
        table.insert(not_exists, 1, current)
        current = vim.fs.dirname(current)
      end
      for _, dir in ipairs(not_exists) do
        IO.fs_mkdir(dir, mode):await()
      end
    end
  end)
end

---Remove file or directory.
---@param start_path string
---@param option? { recursive?: boolean }
function IO.rm(start_path, option)
  start_path = IO.normalize(start_path)
  option = option or {}
  option.recursive = option.recursive or false
  return Async.run(function()
    local stat = IO.fs_stat(start_path):await()
    if stat.type == 'directory' then
      local children = IO.scandir(start_path):await()
      if not option.recursive and #children > 0 then
        error(('IO.rm: `%s` is a directory and not empty.'):format(start_path))
      end
      IO.walk(start_path, function(entry)
        if entry.type == 'directory' then
          IO.fs_rmdir(entry.path):await()
        else
          IO.fs_unlink(entry.path):await()
        end
      end, { postorder = true }):await()
    else
      IO.fs_unlink(start_path):await()
    end
  end)
end

---Copy file or directory.
---@param from any
---@param to any
---@param option? { recursive?: boolean }
---@return ___plugin_name___.kit.Async.AsyncTask
function IO.cp(from, to, option)
  from = IO.normalize(from)
  to = IO.normalize(to)
  option = option or {}
  option.recursive = option.recursive or false
  return Async.run(function()
    local stat = IO.fs_stat(from):await()
    if stat.type == 'directory' then
      if not option.recursive then
        error(('IO.cp: `%s` is a directory.'):format(from))
      end
      IO.walk(from, function(entry)
        local new_path = entry.path:gsub(vim.pesc(from), to)
        if entry.type == 'directory' then
          IO.mkdir(new_path, tonumber(stat.mode, 10), { recursive = true }):await()
        else
          IO.cp(entry.path, new_path):await()
        end
      end):await()
    else
      IO.fs_copyfile(from, to):await()
    end
  end)
end

---Walk directory entries recursively.
---@param start_path string
---@param callback fun(entry: { path: string, type: string }): ___plugin_name___.kit.IO.WalkStatus?
---@param option? { postorder?: boolean }
function IO.walk(start_path, callback, option)
  start_path = IO.normalize(start_path)
  option = option or {}
  option.postorder = option.postorder or false
  return Async.run(function()
    local function walk(path)
      for _, entry in ipairs(IO.scandir(path):await()) do
        if entry.type == 'directory' then
          if not option.postorder then
            if callback(entry) ~= IO.WalkStatus.SkipDir then
              walk(entry.path)
            end
          else
            walk(entry.path)
            callback(entry)
          end
        else
          callback(entry)
        end
      end
    end

    local stat = IO.fs_stat(start_path):await()
    if stat.type ~= 'directory' then
      error(('IO.walk: `%s` is not a directory.'):format(start_path))
    end
    if not option.postorder then
      if callback({ path = start_path, type = 'directory' }) ~= IO.WalkStatus.SkipDir then
        walk(start_path)
      end
    else
      walk(start_path)
      callback({ path = start_path, type = 'directory' })
    end
  end)
end

---Scan directory entries.
---@param path string
---@return ___plugin_name___.kit.Async.AsyncTask
function IO.scandir(path)
  path = IO.normalize(path)
  return Async.run(function()
    -- Check the path is directory. If not, throw error.
    local stat = IO.fs_stat(path):await()
    if stat.type ~= 'directory' then
      error(('IO.scandir: `%s` is not a directory.'):format(path))
    end

    local fd = IO.fs_opendir(path):await()
    local entries = {}
    local ok, err = pcall(function()
      while true do
        local chunk = IO.fs_readdir(fd):await()
        if not chunk then
          break
        end
        for _, entry in ipairs(chunk) do
          table.insert(entries, {
            type = entry.type,
            path = path .. '/' .. entry.name,
          })
        end
      end
    end)
    IO.fs_closedir(fd):await()
    if not ok then
      error(err)
    end
    return entries
  end)
end

---Return normalized path.
---@param path string
---@return string
function IO.normalize(path)
  return vim.fs.normalize(vim.fn.fnamemodify(path, ':p'):gsub('/$', ''))
end

return IO
