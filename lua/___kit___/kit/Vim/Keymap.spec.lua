local Async = require('___kit___.kit.Async')
local Keymap = require('___kit___.kit.Vim.Keymap')

describe('kit.Vim.Keymap', function()
  before_each(function()
    vim.cmd([[
      enew!
      set noswapfile
    ]])
  end)

  it('should work with async-await and exceptions', function()
    local _, err = pcall(function()
      Keymap.spec(Async.async(function()
        Keymap.send('iinsert', 'n'):await()
        error('error')
      end))
    end)
    assert.are_not.equals(
      string.match(
        err--[[@as string]],
        'error$'
      ),
      nil
    )
  end)
end)
