---Return script path.
---@return string
local function get_script_path()
  return debug.getinfo(2, 'S').source:sub(2):match('(.*/)')
end

---Execute system command.
---@param command string
---@param confirm boolean
local function execute(command, confirm)
  if confirm then
    vim.cmd([[redraw]])
    local input = vim.fn.input(('---\n%s\n---\nExecute command? (y/n): '):format(command))
    if input ~= 'y' then
      return false
    end
  end

  vim.cmd([[redraw]])
  vim.api.nvim_echo({{ command, 'Special' }}, true, {})
  vim.api.nvim_echo(vim.tbl_map(function(output)
    return { output, 'Comment' }
  end, vim.fn.systemlist(command)), true, {})
  return true
end

---Install kit.
return function()
  vim.cmd([[redraw]])
  local install_path = vim.fn.expand(vim.fn.input('install_path: ', '', 'file'), ':p')
  if install_path == '' then
    vim.cmd([[redraw]])
    return vim.api.nvim_echo({{ 'Cancelled.', 'Normal' }}, true, {})
  end
  if vim.fn.isdirectory(install_path) ~= 1 then
    vim.cmd([[redraw]])
    return vim.api.nvim_echo({{ '`install_path` is not directory.', 'ErrorMsg' }}, true, {})
  end

  vim.cmd([[redraw]])
  local plugin_name = vim.fn.input('plugin_name: ')
  if plugin_name == '' then
    vim.cmd([[redraw]])
    return vim.api.nvim_echo({{ 'Cancelled.', 'Normal' }}, false, {})
  end
  if not string.match(plugin_name, '[%a_]+') then
    vim.cmd([[redraw]])
    return vim.api.nvim_echo({{ '`plugin_name` must be [a-zA-Z_].', 'ErrorMsg' }}, true, {})
  end

  local kit_path = ([[%s/lua/%s/kit]]):format(install_path, plugin_name)
  if vim.fn.isdirectory(install_path) then
    if not execute(([[rm -rf %s]]):format(kit_path), true) then
      vim.cmd([[redraw]])
      return vim.api.nvim_echo({{ 'command execution cancelled.', 'ErrorMsg' }}, true, {})
    end
  end

  execute(([[cp -r %s/___plugin_name___ %s]]):format(vim.fn.fnamemodify(get_script_path(), ':p:h:h'), kit_path), false)
  execute(([[find %s -name "*.lua" | xargs sed -i '' 's/___plugin_name___/%s.kit/g']]):format(kit_path, plugin_name), false)
end

