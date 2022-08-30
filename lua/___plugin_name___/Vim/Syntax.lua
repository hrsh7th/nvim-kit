local kit = require('___plugin_name___')

local Syntax = {}

---Get all syntax groups for specified position.
---NOTE: This function accepts 0-origin cursor position.
---@param cursor number[]
---@return string[]
function Syntax.get_syntax_groups(cursor)
  return kit.concat(Syntax.get_vim_syntax_groups(cursor), Syntax.get_treesitter_syntax_groups(cursor))
end

---Get vim's syntax groups for specified position.
---NOTE: This function accepts 0-origin cursor position.
---@param cursor number[]
---@return string[]
function Syntax.get_vim_syntax_groups(cursor)
  local groups = {}
  for _, syntax_id in ipairs(vim.fn.synstack(cursor[1] + 1, cursor[2] + 1)) do
    table.insert(groups, vim.fn.synIDattr(vim.fn.synIDtrans(syntax_id), 'name'))
  end
  return groups
end

---Get tree-sitter's syntax groups for specified position.
---NOTE: This function accepts 0-origin cursor position.
---@param cursor number[]
---@return string[]
function Syntax.get_treesitter_syntax_groups(cursor)
  local bufnr = vim.api.nvim_get_current_buf()

  local highlighter = vim.treesitter.highlighter.active[bufnr]
  if not highlighter then
    return {}
  end

  local names = {}
  highlighter.tree:for_each_tree(function(tstree, ltree)
    if not tstree then
      return
    end

    local root = tstree:root()
    if vim.treesitter.is_in_node_range(root, cursor[1], cursor[2]) then
      local query = highlighter:get_query(ltree:lang()):query()
      for id, node in query:iter_captures(root, bufnr, cursor[1], cursor[1] + 1) do
        if vim.treesitter.is_in_node_range(node, cursor[1], cursor[2]) then
          pcall(function()
            local name = ('@%s'):format(query.captures[id])
            vim.api.nvim_get_hl_by_name(name, true)
            table.insert(names, name)
          end)
        end
      end
    end
  end)
  return names
end

return Syntax

