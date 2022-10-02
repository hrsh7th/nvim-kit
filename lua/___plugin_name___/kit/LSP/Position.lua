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

---Create cursor position.
function Position.cursor(encoding)
end

---Convert position to utf8 from specified encoding.
---@param text string
---@param position ___plugin_name___.kit.LSP.Position
---@param from_encoding? ___plugin_name___.kit.LSP.PositionEncoding
---@return ___plugin_name___.kit.LSP.Position
function Position.to_utf8(text, position, from_encoding)
  from_encoding = from_encoding or Position.Encoding.UTF16

  if from_encoding == Position.Encoding.UTF8 then
    return position
  end

  local ok, byteindex = pcall(function()
    return vim.str_byteindex(text, position.character, from_encoding == Position.Encoding.UTF16)
  end)
  if not ok then
    return position
  end
  return { line = position.line, character = byteindex }
end

---Convert position to utf16 from specified encoding.
---@param text string
---@param position ___plugin_name___.kit.LSP.Position
---@param from_encoding? ___plugin_name___.kit.LSP.PositionEncoding
---@return ___plugin_name___.kit.LSP.Position
function Position.to_utf16(text, position, from_encoding)
  local utf8 = Position.to_utf8(text, position, from_encoding)
  for index = utf8.character, 0, -1 do
    local ok, utf16index = pcall(function()
      return select(2, vim.str_utfindex(text, index))
    end)
    if ok then
      return { line = utf8.line, character = utf16index }
    end
  end
  return position
end

---Convert position to utf32 from specified encoding.
---@param text string
---@param position ___plugin_name___.kit.LSP.Position
---@param from_encoding? ___plugin_name___.kit.LSP.PositionEncoding
---@return ___plugin_name___.kit.LSP.Position
function Position.to_utf32(text, position, from_encoding)
  local utf8 = Position.to_utf8(text, position, from_encoding)
  for index = utf8.character, 0, -1 do
    local ok, utf32index = pcall(function()
      return select(1, vim.str_utfindex(text, index))
    end)
    if ok then
      return { line = utf8.line, character = utf32index }
    end
  end
  return position
end

return Position
