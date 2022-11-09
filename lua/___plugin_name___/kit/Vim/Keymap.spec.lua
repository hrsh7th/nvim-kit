local Async = require('___plugin_name___.kit.Async')
local Keymap = require('___plugin_name___.kit.Vim.Keymap')

describe('kit.Vim.Keymap', function()
  before_each(function()
    vim.cmd([[
      enew!
      set noswapfile
    ]])
  end)

  it('should work with async-await and exceptions', function()
    local ok, err = pcall(function()
      Keymap.spec(Async.async(function()
        Keymap.send('iinsert', 'n'):await()
        error('error')
      end))
    end)
    if not ok then
      assert.are_not.equals(
        string.match(
          err--[[@as string]] ,
          'error$'
        ),
        nil
      )
    end
  end)

  it('should insert multiple keys in order', function()
    vim.keymap.set(
      'i',
      '<Plug>(kit.Vim.Keymap.send)',
      Async.async(function()
        Keymap.send('foo', 'in'):await()
        assert.are.equals(vim.api.nvim_get_current_line(), '{foo')
        Keymap.send('bar', 'in'):await()
        assert.are.equals(vim.api.nvim_get_current_line(), '{foobar')
        Keymap.send('baz', 'in'):await()
        assert.are.equals(vim.api.nvim_get_current_line(), '{foobarbaz')
      end)
    )
    Keymap.spec(Async.async(function()
      Keymap.send(Keymap.termcodes('i{<Plug>(kit.Vim.Keymap.send)}'), 'i'):await()
    end))
    assert.are.equals(vim.api.nvim_get_current_line(), '{foobarbaz}')
  end)

  it('should treat flags as separated', function()
    vim.keymap.set(
      'i',
      '<Plug>(kit.Vim.Keymap.send)',
      Async.async(function()
        Keymap.send('foo', 'nt'):await()
      end)
    )
    local _, err = pcall(function()
      Keymap.spec(Async.async(function()
        Keymap.send(Keymap.termcodes('i<Plug>(kit.Vim.Keymap.send)'), 'i'):await()
      end))
    end)
    assert.are_not.equals(string.match(err--[[@as string]] , 'Keymap.send:'), nil)
  end)
end)
