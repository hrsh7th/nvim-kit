local Worker = require('___kit___.kit.Lua.Worker')

Worker.new(function()
  local count = 0
  local IO = require('___kit___.kit.IO')
  return IO.walk('~/', function(_, _)
    count = count + 1
    if count % 10000 == 0 then
      print(count)
    end
  end)
end)():next(function(res)
  vim.pretty_print(res)
end):catch(function(err)
  vim.pretty_print(err)
end)
