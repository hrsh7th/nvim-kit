local System = require('___kit___.kit.System')

describe('kit.System', function()
  describe('LineBuffering', function()
    it('should buffering by line (no ignore empty)', function()
      local expects = {
        '1',
        '',
        '2',
        '',
        '',
        '3',
        '',
        '',
      }
      local c = 1
      local buffer = System.LineBuffering.new({
        ignore_empty = false
      }):create(function(text)
        assert.are.equal(text, expects[c])
        c = c + 1
      end)
      buffer.write('1\n')
      buffer.write('\n')
      buffer.write('2')
      buffer.write('\n\n')
      buffer.write('\n3')
      buffer.write('\n')
      buffer.write('\n')
      buffer.close()
      assert.are.equal(c, 9)
    end)

    it('should buffering by line (ignore empty)', function()
      local expects = {
        '1',
        '2',
        '3',
      }
      local c = 1
      local buffer = System.LineBuffering.new({
        ignore_empty = true
      }):create(function(text)
        assert.are.equal(text, expects[c])
        c = c + 1
      end)
      buffer.write('1\n')
      buffer.write('\n')
      buffer.write('2')
      buffer.write('\n\n')
      buffer.write('\n3')
      buffer.close()
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
  end)
end)
