local RegExp = require('___plugin_name___.kit.Vim.RegExp')

describe('kit.Vim.RegExp', function()
  before_each(function()
    vim.cmd([[
      enew!
      set noswapfile
    ]])
  end)

  describe('.gsub', function()
    it('should replace with vim regex', function()
      assert.are.equals(
        RegExp.gsub('aaa bbbaaa aaaaaa bbaaaa', [[\%(bbb\)\@<!aaa]], 'baz'),
        'baz bbbaaa bazbaz bbbaza'
      )
    end)
  end)

end)
