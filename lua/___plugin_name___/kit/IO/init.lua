local uv = require('luv')
local Async = require('___plugin_name___.kit.Async')

local fs_stat = Async.promisify(uv.fs_stat)
local fs_unlink = Async.promisify(uv.fs_unlink)
local fs_rmdir = Async.promisify(uv.fs_rmdir)
local fs_mkdir = Async.promisify(uv.fs_mkdir)
local fs_copyfile = Async.promisify(uv.fs_copyfile)
local fs_opendir = Async.promisify(uv.fs_opendir)
local fs_closedir = Async.promisify(uv.fs_closedir)
local fs_readdir = Async.promisify(uv.fs_readdir)

local IO = {}

---@enum ___plugin_name___.kit.IO.WalkStatus
IO.WalkStatus = {
  Continue = 1,
  Break = 2,
}

---Create directory.
---@param path string
---@param mode integer
---@param option? { recursive?: boolean }
function IO.mkdir(path, mode, option)
  path = IO.normalize(path)
  option = option or {
    recursive = false,
  }
  return Async.run(function()
    if not option.recursive then
      fs_mkdir(path, mode):await()
    else
      local curr = ''
      for _, dirname in ipairs(vim.split(path, '/', { plain = true })) do
        if dirname ~= '' then
          curr = curr .. '/' .. dirname
          local stat = fs_stat(curr):catch(function() end):await()
          if not stat then
            fs_mkdir(curr, mode):await()
          end
        end
      end
    end
  end)
end

---Remove file or directory.
---@param start_path string
---@param option? { recursive?: boolean }
function IO.rm(start_path, option)
  start_path = IO.normalize(start_path)
  option = option or {
    recursive = false,
  }
  return Async.run(function()
    local function rm(path)
      local stat = fs_stat(start_path):await()
      if stat.type == 'directory' then
        if not option.recursive then
          error(('IO.rm: `%s` is a directory.'):format(path))
        end
        for _, entry in ipairs(IO.ls(path):await()) do
          if entry.type == 'directory' then
            rm(entry.path)
          else
            fs_unlink(entry.path):await()
          end
        end
        fs_rmdir(path):await()
      else
        fs_unlink(path):await()
      end
    end

    rm(start_path)
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
  option = option or {
    recursive = false,
  }
  return Async.run(function()
    local stat = fs_stat(from):await()
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
      fs_copyfile(from, to):await()
    end
  end)
end

---Walk directory entries recursively.
---@param start_path string
---@param callback fun(entry: { path: string, type: string }): ___plugin_name___.kit.IO.WalkStatus?
function IO.walk(start_path, callback)
  start_path = IO.normalize(start_path)
  return Async.run(function()
    local function walk(path)
      for _, entry in ipairs(IO.ls(path):await()) do
        if entry.type == 'directory' then
          if callback(entry) ~= IO.WalkStatus.Break then
            walk(entry.path)
          end
        else
          callback(entry)
        end
      end
    end

    local stat = fs_stat(start_path):await()
    if stat.type ~= 'directory' then
      error(('IO.walk: `%s` is not a directory.'):format(start_path))
    end
    walk(start_path)
  end)
end

---List directory entries.
---@param path string
---@return ___plugin_name___.kit.Async.AsyncTask
function IO.ls(path)
  path = IO.normalize(path)
  return Async.run(function()
    -- Check the path is directory. If not, throw error.
    local stat = fs_stat(path):await()
    if stat.type ~= 'directory' then
      error(('IO.ls: `%s` is not a directory.'):format(path))
    end

    local fd = fs_opendir(path):await()
    local entries = {}
    local ok, err = pcall(function()
      while true do
        local chunk = fs_readdir(fd):await()
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
    fs_closedir(fd):await()
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
