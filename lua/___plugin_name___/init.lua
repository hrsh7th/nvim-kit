local kit = {}

---Merge two tables.
---NOTE: This doesn't merge array-like table.
---@param tbl1 table
---@param tbl2 table
function kit.merge(tbl1, tbl2)
  local is_dict1 = type(tbl1) == 'table' and (not vim.tbl_islist(tbl1) or vim.tbl_isempty(tbl1))
  local is_dict2 = type(tbl2) == 'table' and (not vim.tbl_islist(tbl2) or vim.tbl_isempty(tbl2))
  if is_dict1 and is_dict2 then
    local new_tbl = {}
    for k, v in pairs(tbl2) do
      if tbl1[k] ~= vim.NIL then
        new_tbl[k] = kit.merge(tbl1[k], v)
      end
    end
    for k, v in pairs(tbl1) do
      if tbl2[k] == nil then
        new_tbl[k] = v ~= vim.NIL and v or nil
      end
    end
    return new_tbl
  elseif is_dict1 and not is_dict2 then
    return kit.merge(tbl1, {})
  elseif not is_dict1 and is_dict2 then
    return kit.merge(tbl2, {})
  end

  if tbl1 == vim.NIL then
    return nil
  elseif tbl1 == nil then
    return tbl2
  else
    return tbl1
  end
end

---Concatenate two tables.
---NOTE: This doesn't concatenate dict-like table.
---@param tbl1 table
---@param tbl2 table
function kit.concat(tbl1, tbl2)
  local new_tbl = {}
  for _, item in ipairs(tbl1) do
    table.insert(new_tbl, item)
  end
  for _, item in ipairs(tbl2) do
    table.insert(new_tbl, item)
  end
  return new_tbl
end

return kit

