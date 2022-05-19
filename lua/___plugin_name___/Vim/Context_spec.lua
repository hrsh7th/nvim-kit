local Context = require('___plugin_name___.Vim.Context')

describe('kit.Vim.Context', function()

  before_each(function()
    vim.cmd([[
      enew!
      call setline(1, ['let var1 = 1', 'let var2 = 2'])
    ]])
  end)

  it('should return cursor', function()
    vim.api.nvim_win_set_cursor(0, { 1, 8 })
    local context = Context.new()
    assert.are.same(context, {
      tab = vim.api.nvim_get_current_tabpage(),
      win = vim.api.nvim_get_current_win(),
      buf = vim.api.nvim_get_current_buf(),
      cursor = {
        row = 0,
        col = 8,
        before_text = 'let var1',
        after_text = ' = 1',
      }
    })
  end)

end)
