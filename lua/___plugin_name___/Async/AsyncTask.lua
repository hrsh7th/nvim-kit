---@class kit.Async.AsyncTask
---@field private status kit.Async.AsyncTask.Status
---@field private values any
---@field private children ({ on_fulfilled: (fun(value: any): any), on_rejected: (fun(value: any): any) })[]
local AsyncTask = {}

AsyncTask.__index = AsyncTask

---@alias kit.Async.AsyncTask.Status 0|1|2
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
---@NOET: The AsyncTask has similar interface to JavaScript Promise but it has important differences that the AsyncTask isn't `always asynchronous`.
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
        c.on_fulfilled(unpack(self.values))
      end
    end, function(...)
      self.status = AsyncTask.Status.Rejected
      self.values = { ... }
      for _, c in ipairs(self.children) do
        c.on_rejected(self.values[1])
      end
    end)
  end)
  if not ok then
    self.status = AsyncTask.Status.Rejected
    self.values = { err }
    for _, c in ipairs(self.children) do
      c.on_rejected(self.values[1])
    end
  end
  return self
end

---Register next step.
---@param on_fulfilled fun(value: any): any
---@param on_rejected? fun(value: any): any
function AsyncTask:next(on_fulfilled, on_rejected)
  if self.status == AsyncTask.Status.Pending then
    return AsyncTask.new(function(resolve, reject)
      table.insert(self.children, {
        on_fulfilled = function(...)
          local values = { on_fulfilled(...) }
          if AsyncTask.is(values[1]) then
            values[1]:next(resolve, reject)
          else
            resolve(unpack(values))
          end
        end,
        on_rejected = function(err)
          if on_rejected then
            local values = { on_rejected(err) }
            if AsyncTask.is(values[1]) then
              values[1]:next(resolve, reject)
            else
              resolve(values[1])
            end
          else
            reject(err)
          end
        end,
      })
    end)
  else
    return AsyncTask.new(function(resolve, reject)
      if self.status == AsyncTask.Status.Fulfilled then
        local values = { on_fulfilled(unpack(self.values)) }
        if AsyncTask.is(values[1]) then
          values[1]:next(resolve, reject)
        else
          resolve(unpack(values))
        end
      else
        if on_rejected then
          local values = { on_rejected(self.values[1]) }
          if AsyncTask.is(values[1]) then
            values[1]:next(resolve, reject)
          else
            resolve(values[1])
          end
        else
          reject(self.values[1])
        end
      end
    end)
  end
end

---Register catch step.
---@param on_rejected fun(value: any): any
---@return kit.Async.AsyncTask
function AsyncTask:catch(on_rejected)
  return self:next(function(value)
    return value
  end, on_rejected)
end

---Sync async task.
---@param timeout? number
---@return any
function AsyncTask:sync(timeout)
  vim.wait(timeout or 24 * 60 * 60 * 1000, function()
    return self.status ~= AsyncTask.Status.Pending
  end)
  if self.status == AsyncTask.Status.Rejected then
    error(self.values[1])
  end
  return unpack(self.values)
end

return AsyncTask
