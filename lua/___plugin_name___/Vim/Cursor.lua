---@class kit.Vim.Cursor
---@field public row number # 0-indexed
---@field public col number # 0-indexed
---@field public before_text string
---@field public after_text string
local Cursor = {}

---Create new cursor.
function Cursor.new()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local text = vim.api.nvim_get_current_line()
  local self = setmetatable({}, { __index = Cursor })
  self.row = cursor[1] - 1
  self.col = cursor[2]
  self.before_text = string.sub(text, 1, self.col)
  self.after_text = string.sub(text, self.col + 1)
  return self
end

return Cursor

