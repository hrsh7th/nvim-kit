local Position = require('___plugin_name___.kit.LSP.Position')

describe('kit.Vim.Buffer', function()

  local text = '🗿🗿🗿'

  before_each(function()
    vim.cmd(([[
      enew!
      set noswapfile
      call setline(1, ['%s'])
    ]]):format(text))
  end)

  it('should convert utf8 to utf8', function()
    assert.are.same(Position.to_utf8({
      line = 0,
      character = #text
    }, Position.Encoding.UTF8, vim.api.nvim_get_current_line()), {
      line = 0,
      character = #text
    })
  end)

  it('should convert utf16 to utf8', function()
    assert.are.same(Position.to_utf8({
      line = 0,
      character = select(2, vim.str_utfindex(text))
    }, Position.Encoding.UTF16, vim.api.nvim_get_current_line()), {
      line = 0,
      character = #text
    })
  end)

  it('should convert utf32 to utf8', function()
    assert.are.same(Position.to_utf8({
      line = 0,
      character = select(1, vim.str_utfindex(text))
    }, Position.Encoding.UTF32, vim.api.nvim_get_current_line()), {
      line = 0,
      character = #text
    })
  end)

end)

