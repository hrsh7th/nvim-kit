local Async = {}

---@alias kit.Async.Status 'pending'|'complete'
Async.Status = {}
Async.Status.Pending = 'pending'
Async.Status.Complete = 'complete'

---The constructor of Async.
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

function Progress:sync(timeout)
  vim.wait(timeout or 1000, function()
    return self.status == Async.Status.Complete
  end)
  if self.err then
    error(self.err)
  end
  return unpack(self.res)
end

function Progress:__call(callback)
  if self.status == Async.Status.Pending then
    table.insert(self.callbacks, callback)
  elseif self.status == Async.Status.Complete then
    callback(self.err, unpack(self.res))
  end
end

---Create async function.
function Async.run(fn)
  local thread = coroutine.create(fn)
  return Async.async(function(callback)
    local function next_step(ok, ...)
      if coroutine.status(thread) == 'dead' then
        if ok then
          callback(nil, ...)
        else
          callback(...)
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
function Async.async(runner)
  local progress = Progress.new()
  runner(function(err, ...)
    progress.err = err
    progress.res = { ... }
    progress.status = Async.Status.Complete
    for _, callback in ipairs(progress.callbacks) do
      callback(progress.err, unpack(progress.res))
    end
  end)
  return progress
end

---Await progress.
---@return any
function Async.await(progres_or_value)
  if getmetatable(progres_or_value) == Progress then
    local res = { coroutine.yield(progres_or_value) }
    if res[1] then
      error(res[1])
    end
    return res[2]
  end
  return progres_or_value
end

return Async

