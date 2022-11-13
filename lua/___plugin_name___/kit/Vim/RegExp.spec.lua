local RegExp = require('___plugin_name___.kit.Vim.RegExp')

describe('kit.Vim.RegExp', function()
  describe('.gsub', function()
    it('should replace with vim regex', function()
      assert.are.equals(
        RegExp.gsub('aaa bbbaaa aaaaaa bbaaaa', [[\%(bbb\)\@<!aaa]], 'baz'),
        'baz bbbaaa bazbaz bbbaza'
      )
    end)
    it('should replace like string.gsub', function()
      assert.are.equals(
        RegExp.gsub('aaaaa', [[aa]], 'a'),
        string.gsub('aaaaa', 'aa', 'a')
      )
      assert.are.equals(
        RegExp.gsub('aaaaa', [[a]], 'aa'),
        string.gsub('aaaaa', 'a', 'aa')
      )
      assert.are.equals(
        RegExp.gsub('aaaaa', [[aa]], 'aa'),
        string.gsub('aaaaa', 'aa', 'aa')
      )
    end)
  end)
end)
