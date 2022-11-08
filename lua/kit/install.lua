---Return script path.
---@return string
local function get_script_path()
  return debug.getinfo(2, 'S').source:sub(2):match('(.*/)')
end

---Execute system command.
---@param bang integer
---@param command string
---@param confirm boolean
local function execute(bang, command, confirm)
  if confirm then
    vim.cmd([[redraw]])
    if bang == 0 then
      local input = vim.fn.input(('---\n%s\n---\nExecute command? (y/n): '):format(command))
      if input ~= 'y' then
        return false
      end
    end
  end

  vim.cmd([[redraw]])
  vim.api.nvim_echo({ { command, 'Special' } }, true, {})
  vim.api.nvim_echo(
    vim.tbl_map(function(output)
      return { output, 'Comment' }
    end, vim.fn.systemlist(command)),
    true,
    {}
  )
  return true
end

---Install kit.
return function(bang, install_path, plugin_name)
  if not install_path or install_path == '' then
    vim.cmd([[redraw]])
    install_path = vim.fn.expand(vim.fn.input('install_path: ', '', 'file'), ':p')
    if install_path == '' then
      vim.cmd([[redraw]])
      return vim.api.nvim_echo({ { 'Cancelled.', 'Normal' } }, true, {})
    end
  end
  if vim.fn.isdirectory(install_path) ~= 1 then
    vim.cmd([[redraw]])
    return vim.api.nvim_echo({ { '`install_path` is not directory.', 'ErrorMsg' } }, true, {})
  end

  if not plugin_name or plugin_name == '' then
    vim.cmd([[redraw]])
    plugin_name = vim.fn.input('plugin_name: ')
    if plugin_name == '' then
      vim.cmd([[redraw]])
      return vim.api.nvim_echo({ { 'Cancelled.', 'Normal' } }, false, {})
    end
  end
  if not string.match(plugin_name, '[%a_]+') then
    vim.cmd([[redraw]])
    return vim.api.nvim_echo({ { '`plugin_name` must be [a-zA-Z_].', 'ErrorMsg' } }, true, {})
  end

  local kit_path = ([[%s/lua/%s/kit]]):format(install_path, plugin_name)
  if vim.fn.isdirectory(install_path) then
    if not execute(bang, ([[rm -rf %s]]):format(kit_path), true) then
      vim.cmd([[redraw]])
      return vim.api.nvim_echo({ { 'command execution cancelled.', 'ErrorMsg' } }, true, {})
    end
  end

  execute(bang, ([[cp -r %s/___plugin_name___/kit %s]]):format(vim.fn.fnamemodify(get_script_path(), ':p:h:h'), kit_path), false)
  execute(bang, ([[find %s -name "*.lua" | xargs sed -i '' 's/___plugin_name___/%s/g']]):format(kit_path, plugin_name), false)
  execute(bang, ([[find %s -name "*.lua" | xargs sed -i '' '/.*kit\.macro\.remove.*/d']]):format(kit_path), false)
  execute(bang, ([[rm -r %s/**/*.spec.lua]]):format(kit_path), false)
end
