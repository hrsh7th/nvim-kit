if vim.g.loaded_kit then
  return
end
vim.g.loaded_kit = true

vim.cmd([[
  command! KitInstall lua require('kit.install')()
]])

