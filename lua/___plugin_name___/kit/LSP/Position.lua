local Buffer = require('___plugin_name___.kit.Vim.Buffer')

---@class ___plugin_name___.kit.LSP.Position
---@field public line integer
---@field public character integer

local Position = {}

---@alias ___plugin_name___.kit.LSP.PositionEncoding 'utf8'|'utf16'|'utf32'
Position.Encoding = {}
Position.Encoding.UTF8 = 'utf8'
Position.Encoding.UTF16 = 'utf16'
Position.Encoding.UTF32 = 'utf32'

---Convert position to utf8 from specified encoding.
---@param position ___plugin_name___.kit.LSP.Position
---@param encoding? ___plugin_name___.kit.LSP.PositionEncoding
---@param text string
function Position.to_utf8(position, encoding, text)
  encoding = encoding or Position.Encoding.UTF16

  if encoding == Position.Encoding.UTF8 then
    return position
  end

  local ok, byteindex = pcall(function()
    return vim.str_byteindex(text, position.character, encoding == Position.Encoding.UTF16)
  end)
  if not ok then
    return position
  end
  return { line = position.line, character = byteindex }
end

return Position
