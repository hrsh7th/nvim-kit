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
      buffer.write('\n3')
      buffer.close()
      assert.are.equals(count, 3)
    end)
  end)
  describe('DelimiterBuffering', function()
    it('should buffering by delimiter', function()
      local buffer, consumed
      consumed = {}
      buffer = System.DelimiterBuffering.new({ delimiter = '\t\t\n' }):create(function(text)
        table.insert(consumed, text)
      end)
      buffer.write('1')
      buffer.write('\t\t\n2\t')
      buffer.write('\t\n3\t\t')
      buffer.write('\n4\t\t\n')
      buffer.write('5')
      buffer.write('\t\t\n')
      buffer.write('6')
      buffer.write('\t\t\n')
      buffer.write('\t')
      buffer.write('\t')
      buffer.write('\n')
      buffer.write('7')
      buffer.close()
      assert.are.same(consumed, { '1', '2', '3', '4', '5', '6', '', '7' })

      consumed = {}
      buffer = System.DelimiterBuffering.new({ delimiter = '\t\t\n' }):create(function(text)
        table.insert(consumed, text)
      end)
      buffer.write('1\t\t\n2\t\t\n3\t\t\n4\t\t\n5\t\t\n6\t\t\n\t\t\n7')
      buffer.close()
      assert.are.same(consumed, { '1', '2', '3', '4', '5', '6', '', '7' })
    end)
    describe('PatternBuffering', function()
      it('should buffering by pattern', function()
        local consumed = {}
        local buffer = System.PatternBuffering.new({ pattern = '\t\t\n' }):create(function(text)
          table.insert(consumed, text)
        end)
        buffer.write('1')
        buffer.write('\t\t\n2\t')
        buffer.write('\t\n3\t\t')
        buffer.write('\n4\t\t\n')
        buffer.write('5')
        buffer.write('\t\t\n')
        buffer.write('6')
        buffer.write('\t\t\n')
        buffer.write('\t')
        buffer.write('\t')
        buffer.write('\n')
        buffer.write('7')
        buffer.write('\t')
        buffer.write('\t')
        buffer.write('\n')
        buffer.write('8')
        buffer.close()
        assert.are.same(consumed, { '1', '2', '3', '4', '5', '6', '', '7', '8' })
      end)
    end)
  end)
end)
