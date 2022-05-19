local Cursor = require('___plugin_name___.Vim.Cursor')

describe('kit.Vim.Cursor', function()

  before_each(function()
    vim.cmd([[
      enew!
      call setline(1, ['let var1 = 1', 'let var2 = 2'])
    ]])
  end)

  it('should return cursor', function()
    vim.api.nvim_win_set_cursor(0, { 1, 8 })
    local cursor = Cursor.new()
    assert.are.same(cursor, {
      row = 0,
      col = 8,
      before_text = 'let var1',
      after_text = ' = 1',
    })
  end)

end)

