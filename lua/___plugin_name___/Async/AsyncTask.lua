---@class kit.Async.AsyncTask
---@field private status kit.Async.AsyncTask.Status
---@field private values any
---@field private children (fun(): void)[]
local AsyncTask = {}
AsyncTask.__index = AsyncTask

---@alias kit.Async.AsyncTask.Status integer
AsyncTask.Status = {}
AsyncTask.Status.Pending = 0
AsyncTask.Status.Fulfilled = 1
AsyncTask.Status.Rejected = 2

---Return the value is AsyncTask or not.
---@param value any
---@return boolean
function AsyncTask.is(value)
  return getmetatable(value) == AsyncTask
end

---Create resolved AsyncTask.
---@param v any
---@param ... any
---@return kit.Async.AsyncTask
function AsyncTask.resolve(v, ...)
  if AsyncTask.is(v) then
    return v
  end
  local args = { ... }
  return AsyncTask.new(function(resolve)
    resolve(v, unpack(args))
  end)
end

---Create new AsyncTask.
---@NOET: The AsyncTask has similar interface to JavaScript Promise but the AsyncTask can be worked as synchronous.
---@param v any
---@return kit.Async.AsyncTask
function AsyncTask.reject(v)
  if AsyncTask.is(v) then
    return v
  end
  return AsyncTask.new(function(_, reject)
    reject(v)
  end)
end

---Create new async task object.
---@param runner any
function AsyncTask.new(runner)
  local self = setmetatable({}, AsyncTask)
  self.status = AsyncTask.Status.Pending
  self.children = {}
  local ok, err = pcall(function()
    runner(function(...)
      self.status = AsyncTask.Status.Fulfilled
      self.values = { ... }
      for _, c in ipairs(self.children) do
        c()
      end
    end, function(...)
      self.status = AsyncTask.Status.Rejected
      self.values = { ... }
      for _, c in ipairs(self.children) do
        c()
      end
    end)
  end)
  if not ok then
    self.status = AsyncTask.Status.Rejected
    self.values = { err }
    for _, c in ipairs(self.children) do
      c()
    end
  end
  return self
end

---Sync async task.
---@NOTE: This method uses `vim.wait` so that this can't wait the typeahead to be empty.
---@param timeout? number
---@return any
function AsyncTask:sync(timeout)
  vim.wait(timeout or 24 * 60 * 60 * 1000, function()
    return self.status ~= AsyncTask.Status.Pending
  end, 0)
  if self.status == AsyncTask.Status.Rejected then
    error(unpack(self.values))
  end
  return unpack(self.values)
end

---Register next step.
---@param on_fulfilled fun(value: any): any
function AsyncTask:next(on_fulfilled)
  return self:_dispatch(on_fulfilled, function(...)
    error(...)
  end)
end

---Register catch step.
---@param on_rejected fun(value: any): any
---@return kit.Async.AsyncTask
function AsyncTask:catch(on_rejected)
  return self:_dispatch(function(...)
    return ...
  end, on_rejected)
end

---Dispatch task state.
---@param on_fulfilled fun(...: any): any
---@param on_rejected fun(...: any): any
---@return kit.Async.AsyncTask
function AsyncTask:_dispatch(on_fulfilled, on_rejected)
  local function dispatch(resolve, reject)
    if self.status == AsyncTask.Status.Fulfilled then
      local values = { on_fulfilled(unpack(self.values)) }
      if AsyncTask.is(values[1]) then
        values[1]:next(resolve, reject)
      else
        resolve(unpack(values))
      end
    else
      local values = { on_rejected(self.values[1]) }
      if AsyncTask.is(values[1]) then
        values[1]:next(resolve, reject)
      else
        resolve(values[1])
      end
    end
  end

  if self.status == AsyncTask.Status.Pending then
    return AsyncTask.new(function(resolve, reject)
      table.insert(self.children, function()
        dispatch(resolve, reject)
      end)
    end)
  end
  return AsyncTask.new(dispatch)
end

return AsyncTask

