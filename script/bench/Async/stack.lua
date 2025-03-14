local Async = require('___kit___.kit.Async')

local function fib(n)
  return Async.run(function()
    if n < 2 then
      return n
    end
    return fib(n - 1):await() + fib(n - 2):await()
  end)
end

collectgarbage('collect')
local s = vim.uv.hrtime() / 1000000
fib(26):next(function()
  print('time: ', vim.uv.hrtime() / 1000000 - s)
  print('memory: ', collectgarbage("count") / 1024)
  print('count: ', Async.count)
end)
