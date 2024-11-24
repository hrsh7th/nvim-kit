local System = require('___kit___.kit.System')

describe('kit.System', function()
  describe('LineBuffering', function()
    it('should buffering by line', function()
      local count = 0
      local buffer = System.LineBuffering.new({ ignore_empty = true }):create(function(text)
        count = count + 1
        assert.are.equals(text, tostring(count))
      end)
      buffer.write('1\n')
      buffer.write('\n')
      buffer.write('2')
      buffer.write('\n3\n')
      assert.are.equals(count, 3)
    end)
  end)
  describe('PatternBuffering', function()
    it('should buffering by pattern', function()
      local count = 0
      local buffer = System.PatternBuffering.new({ pattern = '\t\t\t' }):create(function(text)
        count = count + 1
        assert.are.equals(text, tostring(count))
      end)
      buffer.write('1')
      buffer.write('\t\t\t2\t\t\t')
      buffer.write('3\t\t\t')
      buffer.write('4')
      buffer.write('\t\t\t5\t\t\t')
      assert.are.equals(count, 5)
    end)
  end)
end)
