local Async = require('___kit___.kit.Async')
local Keymap = require('___kit___.kit.Vim.Keymap')

describe('kit.Vim.Keymap', function()
  before_each(function()
    vim.cmd([[
      enew!
      set noswapfile
    ]])
  end)

  it('should send multiple keys in sequence', function()
    vim.keymap.set('i', '(', Async.async(function()
      Keymap.send('(', 'in'):await()
      assert.equals('[(', vim.api.nvim_get_current_line())

      Keymap.send(')', 'in'):await()
      assert.equals('[()', vim.api.nvim_get_current_line())

      Keymap.send(Keymap.termcodes('<Left>a<Right>'), 'in'):await()
      assert.equals('[(a)', vim.api.nvim_get_current_line())
    end))
    Keymap.spec(function()
      Keymap.send('i', 'in'):await()
      Keymap.send('[(]', 'i'):await()
      assert.equals('[(a)]', vim.api.nvim_get_current_line())
    end)
  end)

  it('should work with async-await and exceptions', function()
    local _, err = pcall(function()
      Keymap.spec(function()
        Keymap.send('iinsert', 'n'):await()
        error('error')
      end)
    end)
    assert.are_not.equals(
      string.match(
        err--[[@as string]] ,
        'error$'
      ),
      nil
    )
  end)
end)
