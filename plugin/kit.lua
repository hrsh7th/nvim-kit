if vim.g.loaded_kit then
  return
end
vim.g.loaded_kit = true

vim.cmd([[
  command! -bang -nargs=* KitInstall lua require('kit.install')('<bang>' == '!', <f-args>)
]])

