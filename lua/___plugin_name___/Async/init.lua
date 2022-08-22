local Async = {}

---@alias kit.Async.Status 'pending'|'canceled'|'complete'
Async.Status = {}
Async.Status.Pending = 'pending'
Async.Status.Canceled = 'canceled'
Async.Status.Complete = 'complete'

---@alias kit.Async.CancelError
Async.CancelError = 'kit.Async.CancelError'

---@class kit.Async.Progress
---@field public status kit.Async.Status
---@field public res? any
---@field public err? string
---@field private callbacks (fun(err?: string, ...: any))[]
local Progress = {}
Progress.__index = Progress

---Create progress value.
function Progress.new()
  local self = setmetatable({}, Progress)
  self.status = Async.Status.Pending
  self.err = nil
  self.res = nil
  self.callbacks = {}
  return self
end

---Sync progress and return resolved value.
---NOTE: This fucntion uses `vim.wait` so you can't wait the type-ahead is empty.
---@param timeout? integer # default 20 * 10000
---@return any
function Progress:sync(timeout)
  if self.status == Async.Status.Canceled then
    error(Async.CancelError)
  end

  vim.wait(timeout or (20 * 1000), function()
    return self.status == Async.Status.Complete
  end)
  if self.err then
    error(self.err)
  end
  return unpack(self.res)
end

---Cancel progress if this is pending.
function Progress:cancel()
  if self.status == Async.Status.Pending then
    self.status = Async.Status.Canceled
  end
end

---Listen finished this progress.
---@param callback fun(err?: string, ...: any)
function Progress:__call(callback)
  if self.status == Async.Status.Pending then
    table.insert(self.callbacks, callback)
  elseif self.status == Async.Status.Complete then
    callback(self.err, unpack(self.res))
  end
end

---Create async function.
---@generic T
---@param runner fun(): any
---@return kit.Async.Progress
function Async.run(runner)
  local thread = coroutine.create(runner)
  return Async.async(function(callback)
    local function next_step(ok, ...)
      if coroutine.status(thread) == 'dead' then
        if ok then
          callback(nil, ...)
        else
          callback(..., nil)
        end
        return
      end

      local progress_or_value = select(1, ...)
      if getmetatable(progress_or_value) ~= Progress then
        next_step(coroutine.resume(thread, ...))
      else
        progress_or_value(function(...)
          next_step(coroutine.resume(thread, ...))
        end)
      end
    end
    next_step(coroutine.resume(thread))
  end)
end

---Run async function.
---@param runner function
---@return kit.Async.Progress
function Async.async(runner)
  local progress = Progress.new()
  runner(function(err, ...)
    if progress.status == Async.Status.Canceled then
      return
    end
    progress.err = err
    progress.res = { ... }
    progress.status = Async.Status.Complete
    for _, callback in ipairs(progress.callbacks) do
      callback(progress.err, unpack(progress.res))
    end
  end)
  return progress
end

---Await progress or return value.
---@param progress_or_value any
---@return any
function Async.await(progress_or_value)
  if getmetatable(progress_or_value) == Progress then
    local res = { coroutine.yield(progress_or_value) }
    if res[1] then
      error(res[1])
    end
    return res[2]
  end
  return progress_or_value
end

return Async

