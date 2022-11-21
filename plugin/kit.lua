if vim.g.loaded_kit then
  return
end
vim.g.loaded_kit = true

vim.api.nvim_create_user_command("KitInstall", function(option)
  local plugin_path, plugin_name = unpack(option.fargs)
  require("kit.install")(option.bang, plugin_path, plugin_name)
end, {
  bang = true,
  nargs = "*",
})
