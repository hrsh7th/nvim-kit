local AsyncTask = require('___plugin_name___.Async.AsyncTask')

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
  option.insert = option.insert or false
  option.remap = option.remap or false

  return AsyncTask.new(function(resolve)
    if option.insert then
      vim.api.nvim_feedkeys(Keymap.termcodes('<Cmd>lua require("___plugin_name___.Vim.Keymap")._callback()<CR>'), 'in', true)
      vim.api.nvim_feedkeys(keys, 'i' .. (option.remap and 'm' or 'n'), true)
    else
      vim.api.nvim_feedkeys(keys, (option.remap and 'm' or 'n'), true)
      vim.api.nvim_feedkeys(Keymap.termcodes('<Cmd>lua require("___plugin_name___.Vim.Keymap")._callback()<CR>'), 'n', true)
    end
    table.insert(Keymap._callbacks, resolve)
  end)
end

---Test spec helper.
---@param spec fun(): any
function Keymap.spec(spec)
  local task = AsyncTask.resolve(spec())
  vim.api.nvim_feedkeys('', 'x', true)
  task:sync()
end

---Resolve running keys.
function Keymap._callback()
  table.remove(Keymap._callbacks, 1)()
end

return Keymap

