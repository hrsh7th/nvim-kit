local helper = {}

function helper.ensure_treesitter_parser(name)
  vim.cmd(([[
    syntax off
    set filetype=%s
  ]]):format(name))

  vim.treesitter.start(0, name)
  vim.treesitter.get_parser(0, name):parse()
end

return helper
