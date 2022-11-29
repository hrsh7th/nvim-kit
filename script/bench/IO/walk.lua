local IO = require('___kit___.kit.IO')

local count = 0
IO.walk('~/', function(_, _)
  count = count + 1
  if count % 10000 == 0 then
    print(count)
  end
end)
