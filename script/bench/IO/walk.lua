local Worker = require('___kit___.kit.Thread.Worker')

Worker.new(function()
  local count = 0
  local IO = require('___kit___.kit.IO')
  return IO.walk('~/', function(err, _)
    if err then
      print(err)
    end
    count = count + 1
    if count % 10000 == 0 then
      print(count)
    end
  end):next(function(res)
    print(res)
  end):catch(function(err)
    print(err)
  end)
end)()
