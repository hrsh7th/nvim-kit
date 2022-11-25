local LSP = require('___kit___.kit.LSP')
local Position = require('___kit___.kit.LSP.Position')

describe('kit.LSP.Position', function()
  local text = '🗿🗿🗿'
  local utf8 = #text
  local utf16 = select(2, vim.str_utfindex(text, utf8))
  local utf32 = select(1, vim.str_utfindex(text, utf8))

  before_each(function()
    vim.cmd(([[
      enew!
      setlocal noswapfile
      setlocal virtualedit=onemore
      call setline(1, ['%s'])
    ]]):format(text))
  end)

  describe('.is', function()
    it('should accept position', function()
      local position = { line = 0, character = 0 }
      assert.is_true(Position.is(position))
      assert.is_false(Position.is(nil))
      assert.is_false(Position.is(vim.NIL))
      assert.is_false(Position.is(true))
      assert.is_false(Position.is(1))
      assert.is_false(Position.is('1'))
    end)
  end)

  for _, to in ipairs({
    {
      method = 'to_utf8',
      encoding = LSP.PositionEncodingKind.UTF8,
      character = utf8,
    },
    {
      method = 'to_utf16',
      encoding = LSP.PositionEncodingKind.UTF16,
      character = utf16,
    },
    {
      method = 'to_utf32',
      encoding = LSP.PositionEncodingKind.UTF32,
      character = utf32,
    },
  }) do
    for _, from in ipairs({
      { character = utf8, encoding = LSP.PositionEncodingKind.UTF8 },
      { character = utf16, encoding = LSP.PositionEncodingKind.UTF16 },
      { character = utf32, encoding = LSP.PositionEncodingKind.UTF32 },
    }) do
      it(('should convert %s <- %s'):format(to.encoding, from.encoding), function()
        local converted = Position[to.method](text, { line = 1, character = from.character }, from.encoding)
        assert.are.same(to.character, converted.character)
        assert.is_true(Position.is(converted))
        assert.is_true(Position.is(converted, to.encoding))
      end)
    end
  end
end)
