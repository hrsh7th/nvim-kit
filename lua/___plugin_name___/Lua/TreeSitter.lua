local TreeSitter = {}

---@alias kit.Lua.TreeSitter.VisitStatus 'stop'|'skip'
TreeSitter.VisitStatus = {}
TreeSitter.VisitStatus.Stop = 'stop'
TreeSitter.VisitStatus.Skip = 'skip'

---Get the leaf node at the specified position.
---@param row integer # 0-based
---@param col integer # 0-based
---@return userdata?
function TreeSitter.get_node_at(row, col)
  local parser = TreeSitter.get_parser()
  if not parser then
    return
  end

  local function next(node)
    for c in node:iter_children() do
      local _, _, end_row, end_col = c:range()
      local before = row < end_row or (row == end_row and col < end_col)
      if before then
        return next(c)
      end
    end
    return node
  end

  for _, tree in ipairs(parser:trees()) do
    local node = tree:root():descendant_for_range(row, col, row, col)
    if node then
      return next(node)
    end
  end
end

---Extract nodes that matched the specified mapping.
---@param scope userdata
---@param mapping table
---@return userdata[]
function TreeSitter.extract(scope, mapping)
  local nodes = {}
  for node_type, next_mapping in pairs(mapping) do
    if node_type == scope:type() then
      if type(next_mapping) == 'table' then
        for c in scope:iter_children() do
          for _, node in ipairs(TreeSitter.extract(c, next_mapping)) do
            table.insert(nodes, node)
          end
        end
      elseif next_mapping ~= nil then
        table.insert(nodes, scope)
      end
    end
  end
  return nodes
end

---Return the node is matched the specified mapping.
---@param node userdata
---@param mapping table
---@return userdata?
function TreeSitter.matches(node, mapping)
  local parent = node
  while parent do
    if vim.tbl_contains(TreeSitter.extract(parent, mapping), node) then
      return parent
    end
    parent = parent:parent()
  end
end

---Search next specific node.
---@param node userdata
---@param predicate fun(node: userdata): boolean
---@return userdata?
function TreeSitter.search_next(node, predicate)
  local current = node
  while current do
    -- down search.
    local matched = nil
    TreeSitter.visit(current, function(node_)
      if node:id() ~= node_:id() and predicate(node_) then
        matched = node_
        return TreeSitter.VisitStatus.Stop
      end
    end)
    if matched then
      return matched
    end

    -- up search.
    while current do
      local next_sibling = current:next_sibling()
      if next_sibling then
        current = next_sibling
        break
      end
      current = current:parent()
    end
  end
end

---Search next pair.
---@param node userdata
---@param pairs table
---@return userdata?
function TreeSitter.search_next_pair(node, pairs)
  local scope = TreeSitter.matches(node, pairs)
  if not scope then
    local next = TreeSitter.search_next(node, function(node_)
      return TreeSitter.matches(node_, pairs) ~= nil
    end)
    if not next then
      return
    end
    node = next
    scope = TreeSitter.matches(next, pairs)
  end
  if not scope then
    return
  end

  local nodes = TreeSitter.extract(scope, pairs)
  for i, n in ipairs(nodes) do
    if n == node then
      return nodes[(i % #nodes) + 1]
    end
  end
end

---Search specific parent node.
---@param node userdata
---@param predicate fun(node: userdata): boolean
---@return userdata?
function TreeSitter.search_parent(node, predicate)
  local parent = node:parent()
  while parent do
    if predicate(parent) then
      return parent
    end
    parent = parent:parent()
  end
end

---Get all parents.
---@param node userdata
---@return userdata[]
function TreeSitter.parents(node)
  local parents = {}
  while node do
    table.insert(parents, 1, node)
    node = node:parent()
  end
  return parents
end

---Visit all nodes.
---@param scope userdata
---@param predicate fun(node: userdata, ctx: { depth: integer }): boolean
function TreeSitter.visit(scope, predicate)
  local function visit(node, ctx)
    if not node then
      return true
    end

    local status = predicate(node, ctx)
    if status == TreeSitter.VisitStatus.Stop then
      return status -- stop visitting.
    elseif status ~= TreeSitter.VisitStatus.Skip then
      for i = 0, node:child_count() - 1 do
        if visit(node:child(i), { depth = ctx.depth + 1 }) == TreeSitter.VisitStatus.Stop then
          return TreeSitter.VisitStatus.Stop
        end
      end
    end
  end

  return visit(scope, { depth = 1 })
end

---Get node text.
---@param node userdata
---@return string
function TreeSitter.get_node_text(node)
  local ok, text = pcall(function()
    local args = { 0, node:range() }
    table.insert(args, {})
    return vim.api.nvim_buf_get_text(unpack(args))
  end)
  if not ok then
    return ''
  end
  return text
end

---Get parser.
---@return table
function TreeSitter.get_parser()
  return vim.treesitter.get_parser(0, vim.api.nvim_buf_get_option(0, 'filetype'))
end

---Dump node or node-table.
---@param node userdata|userdata[]
function TreeSitter.dump(node)
  if not node then
    return print(node)
  end

  if type(node) == 'table' then
    if #node == 0 then
      return print('empty table')
    end
    for _, v in ipairs(node) do
      TreeSitter.dump(v)
    end
    return
  end

  local message = node:type()
  local current = node:parent()
  while true do
    message = message .. ' < ' .. current:type()
    current = current:parent()
    if not current then
      break
    end
  end
  print(message)
end

return TreeSitter
