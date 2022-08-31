local AsyncTask = require('___plugin_name___.Async.AsyncTask')

local Async = {}

---Create async thread.
function Async.async(runner)
  return function(...)
    local args = { ... }
    return AsyncTask.new(function(resolve, reject)
      local thread = coroutine.create(runner)
      local function next_step(ok, v, ...)
        if coroutine.status(thread) == 'dead' then
          if not ok then
            return reject(v, ...)
          end
          return AsyncTask.resolve(v):next(resolve, reject)
        end

        AsyncTask.resolve(v):next(function(...)
          next_step(coroutine.resume(thread, ...))
        end, function(...)
          next_step(coroutine.resume(thread, ...))
        end)
      end

      next_step(coroutine.resume(thread, unpack(args)))
    end)
  end
end

function Async.await(...)
  return coroutine.yield(AsyncTask.resolve(...))
end

return Async

