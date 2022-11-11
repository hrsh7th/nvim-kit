local RegExp = {}

---@type table<string, { match_str: fun(self, text: string) }>
RegExp._cache = {}

---Create a RegExp object.
---@param pattern string
---@return { match_str: fun(self, text: string) }
function RegExp.get(pattern)
  if not RegExp._cache[pattern] then
    RegExp._cache[pattern] = vim.regex(pattern)
  end
  return RegExp._cache[pattern]
end

---Grep and substitute text.
---@param text string
---@param pattern string
---@param replacement string
---@return string
function RegExp.gsub(text, pattern, replacement)
  local regex = RegExp.get(pattern)

  local new_text = {}
  while true do
    local s, e = regex:match_str(text)
    if not s then
      break
    end
    table.insert(new_text, text:sub(1, s))
    table.insert(new_text, replacement)
    text = text:sub(e + 1)
  end
  table.insert(new_text, text)
  return table.concat(new_text)
end

return RegExp
