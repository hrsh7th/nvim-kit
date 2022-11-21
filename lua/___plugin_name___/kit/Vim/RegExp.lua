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
  return vim.fn.substitute(text, pattern, replacement, "g")
end

return RegExp
