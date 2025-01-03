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
    vim.keymap.set('i', '(', function()
      return Async.run(function()
        Keymap.send('('):await()
        assert.equals('[(', vim.api.nvim_get_current_line())

        Keymap.send(')'):await()
        assert.equals('[()', vim.api.nvim_get_current_line())

        Keymap.send(Keymap.termcodes('<Left>a<Right>')):await()
        assert.equals('[(a)', vim.api.nvim_get_current_line())
      end)
    end)

    Keymap.spec(function()
      Keymap.send('i'):await()
      Keymap.send({ '[', { keys = '(', remap = true }, ']' }):await()
      assert.equals('[(a)]', vim.api.nvim_get_current_line())
    end)
  end)

  it('should work with async-await and exceptions', function()
    local _, err = pcall(function()
      Keymap.spec(function()
        Keymap.send('iinsert'):await()
        error('error')
      end)
    end)
    assert.are_not.equals(string.match(err --[[@as string]], 'error$'), nil)
  end)

  it('should create sendable key notation', function()
    local key = Keymap.to_sendable(function()
      Keymap.send('iin_sendable')
    end)
    Keymap.spec(function()
      Keymap.send(key):await()
    end)
    assert.equals('in_sendable', vim.api.nvim_get_current_line())
  end)

  it('should return correct key notation', function()
    assert.equals(' ', Keymap.normalize('<space>'))
    assert.equals(' ', Keymap.normalize('<Space>'))
    assert.equals('<C-J>', Keymap.normalize('<C-j>'))
    assert.equals('<M-j>', Keymap.normalize('<A-j>'))
    assert.equals('<M-;>', Keymap.normalize('<A-;>'))
  end)
end)
