local Worker = require('___kit___.kit.Async.Worker')

describe('kit.Thread.Worker', function()
  it('should work basic usage', function()
    print('start')
    local worker = Worker.new(function(path)
      require('___kit___.kit.IO').walk(path, function(_, entry)
        print(entry.path)
      end):sync()
    end)
    worker('./fixture'):sync()
    print('finish')
  end)
end)
