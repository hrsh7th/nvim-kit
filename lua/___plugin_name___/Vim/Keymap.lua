local Async = require('___plugin_name___.Async')

local Keymap = {}

Keymap._callbacks = {}

---Replace termcodes.
---@param keys string
---@return string
function Keymap.termcodes(keys)
  return vim.api.nvim_replace_termcodes(keys, true, true, true)
end

---Send keys.
---@param keys string
---@param option { remap: boolean, insert: boolean }
function Keymap.send(keys, option)
  option = option or {}
  return Async.async(function(callback)
    local insert = option.insert or false
    if insert then
      vim.api.nvim_feedkeys(Keymap.termcodes('<Cmd>lua require("___plugin_name___.Vim.Keymap")._callback()<CR>'), 'in', true)
      vim.api.nvim_feedkeys(keys, 'i' .. (option.remap and 'm' or 'n'), true)
    else
      vim.api.nvim_feedkeys(keys, (option.remap and 'm' or 'n'), true)
      vim.api.nvim_feedkeys(Keymap.termcodes('<Cmd>lua require("___plugin_name___.Vim.Keymap")._callback()<CR>'), 'n', true)
    end
    table.insert(Keymap._callbacks, callback)
  end)
end

---Resolve running keys.
function Keymap._callback()
  table.remove(Keymap._callbacks, 1)()
end

return Keymap

