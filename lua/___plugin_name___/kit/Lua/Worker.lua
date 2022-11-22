local uv = require('luv')
local AsyncTask = require('___plugin_name___.kit.Async.AsyncTask')

---@class ___plugin_name___.kit.Lua.WorkerOption
---@field public runtimepath string[]

local Worker = {}
Worker.__index = Worker

--- Create a new thread.
---@param runner function
function Worker.new(runner)
  local self = setmetatable({}, Worker)
  self.runner = string.dump(runner)
  return self
end

--- Start the thread.
---@param ... any
function Worker:run(...)
  local args_ = { ... }
  return AsyncTask.new(function(resolve, reject)
    uv.new_work(function(runner, args, option)
      args = vim.json.decode(args)
      option = vim.json.decode(option)

      --Initialize cwd.
      require('luv').chdir(option.cwd)

      --Initialize package.loaders.
      table.insert(package.loaders, 2, vim._load_package)

      --Run runner function.
      local ok, res = pcall(function()
        return assert(loadstring(runner))(unpack(args))
      end)

      --Return error or result.
      if not ok then
        return res, nil
      else
        return nil, res
      end
    end, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end):queue(
      self.runner,
      vim.json.encode(args_),
      vim.json.encode({
        cwd = vim.fn.getcwd(),
      })
    )
  end)
end

return Worker
