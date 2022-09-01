local Buffer = require('___plugin_name___.Vim.Buffer')

---@class kit.LSP.Position
---@field public line integer
---@field public character integer

local Position = {}

---@alias kit.LSP.PositionEncoding 'utf8'|'utf16'|'utf32'
Position.Encoding = {}
Position.Encoding.UTF8 = 'utf8'
Position.Encoding.UTF16 = 'utf16'
Position.Encoding.UTF32 = 'utf32'

---Convert position to utf8 from specified encoding.
---@param position kit.LSP.Position
---@param encoding? kit.LSP.PositionEncoding
---@param expr? string|integer
function Position.to_utf8(position, encoding, expr)
  encoding = encoding or Position.Encoding.UTF16

  if encoding == Position.Encoding.UTF8 then
    return position
  end

  local ok, byteindex = pcall(function()
    return vim.str_byteindex(Buffer.at(expr or '%', position.line), position.character, encoding == Position.Encoding.UTF16)
  end)
  if not ok then
    return position
  end
  return { line = position.line, character = byteindex }
end

return Position
