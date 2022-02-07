local kit = {}

---Merge two table.
---NOTE: This doesn't merge list-like table.
---@param tbl1 table
---@param tbl2 table
function kit.merge(tbl1, tbl2)
  local is_dict1 = type(tbl1) == 'table' and (not vim.tbl_islist(tbl1) or vim.tbl_isempty(tbl1))
  local is_dict2 = type(tbl2) == 'table' and (not vim.tbl_islist(tbl2) or vim.tbl_isempty(tbl2))
  if is_dict1 and is_dict2 then
    local new_tbl = {}
    for k, v in pairs(tbl2) do
      new_tbl[k] = kit.merge(tbl1[k], v)
    end
    for k, v in pairs(tbl1) do
      if tbl2[k] == nil and v ~= vim.NIL then
        new_tbl[k] = v
      end
    end
    return new_tbl
  end

  if tbl1 == vim.NIL then
    return nil
  elseif tbl1 == nil then
    return tbl2
  else
    return tbl1
  end
end

return kit

