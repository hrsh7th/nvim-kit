local IO = require('___plugin_name___.kit.IO')
local Async = require('___plugin_name___.kit.Async')
local RegExp = require('___plugin_name___.kit.Vim.RegExp')

---Return nvim-kit path.
---@return string
local function get_kit_path()
  local script_path = IO.normalize(debug.getinfo(2, 'S').source:sub(2):match('(.*/)'))
  return vim.fn.fnamemodify(script_path, ':h:h') .. '/lua/___plugin_name___/kit'
end

---Show confirm prompt.
---@param force boolean
---@param prompt string
local function confirm(force, prompt)
  if force then
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
    if vim.fn.isdirectory(plugin_path) ~= 1 then
      vim.cmd([[redraw]])
      return vim.api.nvim_echo({ { '`plugin_path` is not a directory.', 'ErrorMsg' } }, true, {})
    end

    -- Resolve `plugin_name`.
    if not plugin_name or plugin_name == '' then
      vim.cmd([[redraw]])
      plugin_name = vim.fn.input('plugin_name: ')
      if plugin_name == '' then
        vim.cmd([[redraw]])
        return vim.api.nvim_echo({ { 'Cancelled.', 'Normal' } }, false, {})
      end
    end

    -- Check `plugin_name` is valid.
    if not string.match(plugin_name, '[%a_]+') then
      vim.cmd([[redraw]])
      return vim.api.nvim_echo({ { '`plugin_name` must be [a-zA-Z_].', 'ErrorMsg' } }, true, {})
    end

    -- Start install process.
    vim.api.nvim_echo({ { ('\n[%s] Installing...\n'):format(plugin_name), 'Normal' } }, false, {})

    -- Remove old kit if need.
    local kit_install_path = ([[%s/lua/%s/kit]]):format(plugin_path, plugin_name)
    if vim.fn.isdirectory(kit_install_path) then
      confirm(bang, ('[%s] rm -rf %s'):format(plugin_name, kit_install_path))
      IO.rm(kit_install_path, { recursive = true }):await()
    end

    -- Copy new kit.
    confirm(bang, ('[%s] cp -r %s %s'):format(plugin_name, get_kit_path(), kit_install_path))
    IO.cp(get_kit_path(), kit_install_path, { recursive = true }):await()

    -- Remove `*.spec.lue` files.
    IO.walk(kit_install_path, function(entry)
      if entry.type == 'file' then
        if entry.path:match('%.spec%.lua$') then
          IO.rm(entry.path):await()
        else
          local content = IO.read_file(entry.path):await()
          content = RegExp.gsub(content, [=[___plugin_name___]=], plugin_name)
          content = RegExp.gsub(content, [=[[^\n]*kit\.macro\.remove[^\n]*[[:space:]]*]=], '')
          IO.write_file(entry.path, content):await()
        end
      end
    end):await()
  end):catch(function(err)
    if err:match('Cancelled$') then
      vim.api.nvim_echo({ { '\nCancelled.', 'WarningMsg' } }, false, {})
    end
  end):sync()
end
