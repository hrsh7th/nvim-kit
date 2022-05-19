local Cursor = require('___plugin_name___.Vim.Cursor')

---@class kit.Vim.Context
---@field public tab number
---@field public win number
---@field public buf number
---@field public cursor kit.Vim.Cursor
local Context = {}

---Create new context.
function Context.new()
  local self = setmetatable({}, { __index = Context })
  self.tab = vim.api.nvim_get_current_tabpage()
  self.win = vim.api.nvim_get_current_win()
  self.buf = vim.api.nvim_get_current_buf()
  self.cursor = Cursor.new()
  return self
end

return Context

