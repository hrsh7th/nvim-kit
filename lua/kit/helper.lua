local helper = {}

function helper.ensure_treesitter_parser(name)
  vim.cmd(([[
    syntax off
    set filetype=%s
  ]]):format(name))

  vim.o.runtimepath = vim.o.runtimepath .. ',' .. vim.fn.fnamemodify('./tmp/nvim-treesitter', ':p')
  require 'nvim-treesitter'.setup()
  require 'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,
    },
  }
  if not require('nvim-treesitter.parsers').has_parser(name) then
    vim.cmd(([[TSInstallSync! %s]]):format(name))
  else
    vim.cmd(([[TSUpdateSync %s]]):format(name))
  end
  vim.treesitter.get_parser(0, name):parse()
end

return helper
