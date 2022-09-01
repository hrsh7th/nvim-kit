local Position = require('___plugin_name___.LSP.Position')

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
    }, Position.Encoding.UTF8), {
      line = 0,
      character = #text
    })
  end)

  it('should convert utf16 to utf8', function()
    print(vim.inspect({
      line = 0,
      character = select(2, vim.str_utfindex(text))
    }))
    assert.are.same(Position.to_utf8({
      line = 0,
      character = select(2, vim.str_utfindex(text))
    }, Position.Encoding.UTF16), {
      line = 0,
      character = #text
    })
  end)

  it('should convert utf32 to utf8', function()
    print(vim.inspect({
      line = 0,
      character = select(1, vim.str_utfindex(text))
    }))
    assert.are.same(Position.to_utf8({
      line = 0,
      character = select(1, vim.str_utfindex(text))
    }, Position.Encoding.UTF32), {
      line = 0,
      character = #text
    })
  end)

end)

