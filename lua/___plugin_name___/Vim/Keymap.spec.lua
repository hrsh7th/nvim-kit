local Async = require('___plugin_name___.Async')
local Keymap = require('___plugin_name___.Vim.Keymap')

local async = Async.async
local await = Async.await

describe('kit.Vim.Keymap', function()

  it('should insert keysequence with async-await', function()
    Keymap.spec(async(function()
      assert.equal(vim.api.nvim_get_mode().mode, 'n')
      await(Keymap.send('i', { insert = true }))
      assert.equal(vim.api.nvim_get_mode().mode, 'i')
      await(Keymap.send('foo', { insert = true }))
      assert.equal(vim.api.nvim_get_current_line(), 'foo')
      await(Keymap.send('bar', { insert = true }))
      assert.equal(vim.api.nvim_get_current_line(), 'foobar')
      await(Keymap.send('baz', { insert = true }))
      assert.equal(vim.api.nvim_get_current_line(), 'foobarbaz')
    end))
  end)

end)

