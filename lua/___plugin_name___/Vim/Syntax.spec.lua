local Syntax = require('___plugin_name___.Vim.Syntax')

describe('kit.Vim.Syntax', function()

  before_each(function()
    vim.cmd([[
      enew!
      syntax off
      set filetype=vim
      call setline(1, ['let var = 1'])
    ]])
  end)

  it('should return vim syntax group', function()
    vim.cmd([[ syntax on ]])
    assert.are.same(Syntax.get_syntax_groups({ 0, 3 }), {})
    assert.are.same(Syntax.get_syntax_groups({ 0, 4 }), { 'Identifier' })
    assert.are.same(Syntax.get_syntax_groups({ 0, 6 }), { 'Identifier' })
    assert.are.same(Syntax.get_syntax_groups({ 0, 7 }), {})
  end)

  it('should return treesitter syntax group', function()
    vim.o.runtimepath = vim.o.runtimepath .. ',' .. vim.fn.fnamemodify('./tmp/nvim-treesitter', ':p')
    require 'nvim-treesitter'.setup()
    require 'nvim-treesitter.configs'.setup {
      highlight = {
        enable = true,
      },
    }
    vim.fn.execute([[ TSUpdateSync vim ]])
    assert.are.same(Syntax.get_syntax_groups({ 0, 3 }), {})
    assert.are.same(Syntax.get_syntax_groups({ 0, 4 }), { '@variable' })
    assert.are.same(Syntax.get_syntax_groups({ 0, 6 }), { '@variable' })
    assert.are.same(Syntax.get_syntax_groups({ 0, 7 }), {})
  end)

end)
