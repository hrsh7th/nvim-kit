local IO = require('___kit___.kit.IO')
local Async = require('___kit___.kit.Async')
local RegExp = require('___kit___.kit.Vim.RegExp')

---Return nvim-kit path.
---@return string
local function get_kit_path()
  local script_path = IO.normalize(debug.getinfo(2, 'S').source:sub(2):match('(.*/)'))
  return vim.fn.fnamemodify(script_path, ':h:h') .. '/lua/___kit___/kit'
end

---Show confirm prompt.
---@param force boolean
---@param prompt string
local function confirm(force, prompt)
  if force then
    print(prompt)
    return
  end
  local answer = vim.fn.input(prompt .. ' [y/N]: ')
  if answer ~= 'y' and answer ~= 'Y' then
    error('Cancelled')
  end
end

---Install kit.
---@param bang boolean
---@param plugin_path? string
---@param plugin_name? string
return function(bang, plugin_path, plugin_name)
  Async.run(function()
    -- Resolve `plugin_path`.
    if not plugin_path or plugin_path == '' then
      vim.cmd([[redraw]])
      plugin_path = IO.normalize(vim.fn.input('plugin_path: ', '', 'file'))
      if plugin_path == '' then
        vim.cmd([[redraw]])
        return vim.api.nvim_echo({ { 'Cancelled.', 'Normal' } }, true, {})
      end
    end

    -- Check `plugin_path` is a directory.
    if not IO.is_directory(plugin_path):await(true) then
      vim.cmd([[redraw]])
      return vim.api.nvim_echo({ { '`plugin_path` is not a directory.', 'ErrorMsg' } }, true, {})
    end

    -- Resolve `plugin_name`.
    if not plugin_name or plugin_name == '' then
      vim.cmd([[redraw]])
      plugin_name = vim.fn.input('plugin_name: ')
      if plugin_name == '' then
        vim.cmd([[redraw]])
        return vim.api.nvim_echo({ { 'Cancelled.', 'Normal' } }, true, {})
      end
    end

    -- Check `plugin_name` is valid.
    if not string.match(plugin_name, '[%a_]+') then
      vim.cmd([[redraw]])
      return vim.api.nvim_echo({ { '`plugin_name` must be [a-zA-Z_].', 'ErrorMsg' } }, true, {})
    end

    -- Start install process.
    vim.api.nvim_echo({ { ('\n[%s] Installing...\n'):format(plugin_name), 'Normal' } }, true, {})

    -- Remove old kit if need.
    local kit_install_path = ([[%s/lua/%s/kit]]):format(plugin_path, plugin_name)
    if IO.is_directory(kit_install_path):await(true) then
      confirm(bang, ('[%s] rm -rf %s'):format(plugin_name, kit_install_path))
      IO.rm(kit_install_path, { recursive = true }):await(true)
    end

    -- Copy new kit.
    confirm(bang, ('[%s] cp -r %s %s'):format(plugin_name, get_kit_path(), kit_install_path))
    IO.cp(get_kit_path(), kit_install_path, { recursive = true }):await(true)

    -- Remove `*.spec.lue` files.
    IO.walk(kit_install_path, function(err, entry)
      if err then
        vim.api.nvim_echo({ { ('\n[%s] Convert error... %s\n'):format(plugin_name, err), 'Normal' } }, true, {})
      end
      if entry.type == 'file' then
        if entry.path:match('%.spec%.lua$') then
          IO.rm(entry.path):await(true)
        else
          local content = IO.read_file(entry.path):await(true)
          content = RegExp.gsub(content, [=[\V___kit___\m]=], plugin_name)
          content = RegExp.gsub(content, [=[[^\n]*kit\.macro\.remove[^\n]*[[:space:]]*]=], '')
          IO.write_file(entry.path, content):await(true)
        end
      end
    end):await(true)
  end)
      :catch(vim.schedule_wrap(function(err)
        if err:match('Cancelled$') then
          vim.api.nvim_echo({ { '\nCancelled.', 'WarningMsg' } }, true, {})
        else
          vim.api.nvim_echo({ { err, 'ErrorMsg' } }, true, {})
        end
      end))
      :sync()
end
