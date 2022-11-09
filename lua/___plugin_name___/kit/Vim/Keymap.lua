local kit = require('___plugin_name___.kit')
local AsyncTask = require('___plugin_name___.kit.Async.AsyncTask')

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
---@param mode string
function Keymap.send(keys, mode)
  local uuid = kit.uuid()
  return AsyncTask.new(function(resolve)
    Keymap._callbacks[uuid] = resolve

    local callback = Keymap.termcodes(('<Cmd>lua require("___plugin_name___.kit.Vim.Keymap")._resolve(%s)<CR>'):format(uuid))
    if string.match(mode, 'i') then
      vim.api.nvim_feedkeys(callback, 'in', true)
      vim.api.nvim_feedkeys(keys, mode, true)
    else
      vim.api.nvim_feedkeys(keys, mode, true)
      vim.api.nvim_feedkeys(callback, 'n', true)
    end
  end):catch(function()
    Keymap._callbacks[uuid] = nil
  end)
end

---Test spec helper.
---@param spec fun(): any
function Keymap.spec(spec)
  local task = AsyncTask.resolve():next(spec)
  vim.api.nvim_feedkeys('', 'x', true)
  task:sync()
  collectgarbage('collect')
end

---Resolve running keys.
---@param uuid integer
function Keymap._resolve(uuid)
  Keymap._callbacks[uuid]()
  Keymap._callbacks[uuid] = nil
end

return Keymap
