if vim.g.loaded_kit then
  return
end
vim.g.loaded_kit = true

vim.api.nvim_create_user_command("KitInstall", function(opt)
  local install_path, plugin_name = unpack(opt.fargs)
  require("kit.install")(opt.bang, install_path, plugin_name)
end, {
  bang = true,
  nargs = "*",
})
