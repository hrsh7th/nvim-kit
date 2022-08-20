local Promise = require('___plugin_name___.Async.Promise')

local Async = {}

function Async.async(fn)
  return function(...)
    local thread = coroutine.create(function(...)
      return fn(...)
    end)

    local args = { ... }
    return Promise.new(function(resolve, reject)
      local function next_step(ok, ...)
        local values = { ... }
        if coroutine.status(thread) == 'dead' then
          if ok then
            resolve(unpack(values))
          else
            reject(unpack(values))
          end
          return
        end

        if getmetatable(values[1]) ~= Promise then
          if ok then
            next_step(coroutine.resume(thread, ...))
          else
            error(ok)
          end
          return
        end

        values[1]:next(function(...)
          next_step(coroutine.resume(thread, ...))
        end):catch(function(err)
          next_step(coroutine.resume(thread, err))
        end)
      end
      next_step(coroutine.resume(thread, unpack(args)))
    end)
  end
end

function Async.await(promise_or_value)
  return coroutine.yield(promise_or_value)
end

return Async

