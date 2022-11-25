local uv = require('luv')
local AsyncTask = require('___kit___.kit.Async.AsyncTask')

_G.__kit__ = _G.__kit__ or {}
_G.__kit__.Async = _G.__kit__.Async or {}
_G.__kit__.Async.threads = _G.__kit__.Async.threads or {}

local Async = {}

---Run async function immediately.
---@generic T: fun(...): ___kit___.kit.Async.AsyncTask
---@param runner T
---@param ... any
---@return ___kit___.kit.Async.AsyncTask
function Async.run(runner, ...)
  return Async.async(runner)(...)
end

---Create async function.
---@generic T: fun(...): ___kit___.kit.Async.AsyncTask
---@param runner T
---@return T
function Async.async(runner)
  return function(...)
    local args = { ... }
    local thread = coroutine.create(runner)
    return AsyncTask.new(function(resolve, reject)
      _G.__kit__.Async.threads[thread] = true

      local function next_step(ok, v)
        if coroutine.status(thread) == 'dead' then
          _G.__kit__.Async.threads[thread] = nil
          if not ok then
            AsyncTask.reject(v):next(resolve):catch(reject)
          else
            AsyncTask.resolve(v):next(resolve):catch(reject)
          end
          return
        end

        AsyncTask.resolve(v)
          :next(function(...)
            next_step(coroutine.resume(thread, ...))
          end)
          :catch(function(...)
            next_step(coroutine.resume(thread, ...))
          end)
      end

      next_step(coroutine.resume(thread, unpack(args)))
    end)
  end
end

---Await async task.
---@param task ___kit___.kit.Async.AsyncTask
---@return any
function Async.await(task)
  if not _G.__kit__.Async.threads[coroutine.running()] then
    error('`Async.await` must be called in async function.')
  end
  return coroutine.yield(AsyncTask.resolve(task))
end

---Create async function from callback function.
---@generic T: ...
---@param runner fun(...: T)
---@param option? { schedule?: boolean, callback?: integer }
---@return fun(...: T): ___kit___.kit.Async.AsyncTask
function Async.promisify(runner, option)
  option = option or {}
  option.schedule = option.schedule or true
  option.callback = option.callback or nil
  return function(...)
    local args = { ... }
    return AsyncTask.new(function(resolve, reject)
      local max = #args + 1
      local pos = math.min(option.callback or max, max)
      table.insert(args, pos, function(err, ...)
        local schedule = function(f)
          f()
        end
        if not vim.is_thread() then
          if option.schedule and vim.in_fast_event() then
            schedule = vim.schedule
          end
        end
        local value = { ... }
        schedule(function()
          if err then
            reject(err)
          else
            resolve(unpack(value))
          end
        end)
      end)
      runner(unpack(args))
    end)
  end
end

return Async
