---@class ___kit___.kit.App.Command.SubCommandSpecifier
---@field public args table<string|number, fun(input: string):string[]>
---@field public execute fun(params: ___kit___.kit.App.Command.ExecuteParams, arguments: table<string, string>)
---
---@class ___kit___.kit.App.Command.SubCommand: ___kit___.kit.App.Command.SubCommandSpecifier
---@field public name string

---@class ___kit___.kit.App.Command
---@field public name string
---@field public subcommands table<string, ___kit___.kit.App.Command.SubCommand>
local Command = {}
Command.__index = Command

---Create a new command.
---@param name string
---@param subcommand_specifiers table<string, ___kit___.kit.App.Command.SubCommandSpecifier>
function Command.new(name, subcommand_specifiers)
  local subcommands = {}
  for subcommand_name, subcommand_specifier in pairs(subcommand_specifiers) do
    subcommands[subcommand_name] = setmetatable({
      name = subcommand_name,
      args = subcommand_specifier.args,
      execute = subcommand_specifier.execute
    }, Command)
  end
  return setmetatable({
    name = name,
    subcommands = subcommands
  }, Command)
end

---@class ___kit___.kit.App.Command.ExecuteParams
---@field public name string
---@field public args string
---@field public fargs string[]
---@field public nargs string
---@field public bang boolean
---@field public line1 integer
---@field public line2 integer
---@field public range 0|1|2
---@field public count integer
---@field public req string
---@field public mods string
---@field public smods string[]
---Execute command.
---@param params ___kit___.kit.App.Command.ExecuteParams
function Command:execute(params)
  local parsed = self:_parse(params.args)

  local subcommand = self.subcommands[parsed[1].text]
  if not subcommand then
    error(('Unknown subcommand: %s'):format(parsed[1].text))
  end

  local arguments = {}

  local pos = 1
  for i, part in ipairs(parsed) do
    if i > 1 then
      local is_named_argument = vim.iter(pairs(subcommand.args)):any(function(name)
        name = tostring(name)
        return part.text:sub(1, #name + 1) == ('%s='):format(name)
      end)
      if is_named_argument then
        local name, value = part.text:match('^(.-)=(.*)$')
        arguments[name] = value
      else
        arguments[pos] = part.text
        pos = pos + 1
      end
    end
  end

  subcommand.execute(params, arguments)
end

---Complete command.
---@param cmdline string
---@param cursor integer
function Command:complete(cmdline, cursor)
  local parsed = self:_parse(cmdline)

  -- check command.
  if parsed[1].text ~= self.name then
    return {}
  end

  -- check subcommand.
  if parsed[2] and parsed[2].s <= cursor and cursor <= parsed[2].e then
    return vim.iter(pairs(self.subcommands)):map(function(_, subcommand)
      return subcommand.name
    end):totable()
  end

  -- check subcommand name.
  local subcommand = self.subcommands[parsed[2].text]
  if not subcommand then
    return {}
  end

  -- check subcommand args.
  local pos = 1
  for i, part in ipairs(parsed) do
    if i > 2 then
      -- check named args args.
      local is_named_argument_name = vim.regex([=[^--\?[^=]*$]=]):match_str(part.text) ~= nil

      local is_named_argument_value = vim.iter(pairs(subcommand.args)):any(function(name)
        name = tostring(name)
        return part.text:sub(1, #name + 1) == ('%s='):format(name)
      end)

      if part.s <= cursor and cursor <= part.e then
        if is_named_argument_name then
          return vim.iter(pairs(subcommand.args)):map(function(name)
            return name
          end):filter(function(name)
            return type(name) == 'string'
          end):totable()
        elseif is_named_argument_value then
          for name, argument in pairs(subcommand.args) do
            if type(name) == 'string' then
              if part.text:sub(1, #name + 1) == ('%s='):format(name) then
                return argument(part.text:sub(#name + 2))
              end
            end
          end
        elseif subcommand.args[pos] then
          return subcommand.args[pos](part.text:sub(1, cursor - part.s))
        end
      end

      if not is_named_argument_name and not is_named_argument_value then
        pos = pos + 1
      end
    end
  end
end

---Parse command line.
---@param cmdline string
---@return { text: string, s: integer, e: integer }[]
function Command:_parse(cmdline)
  ---@type { text: string, s: integer, e: integer }[]
  local parsed = {}

  local part = {}
  local s = 1
  local i = 1
  while i <= #cmdline do
    local c = cmdline:sub(i, i)
    if c == '\\' then
      table.insert(part, cmdline:sub(i + 1, i + 1))
      i = i + 1
    elseif c == ' ' then
      if #part > 0 then
        table.insert(parsed, {
          text = table.concat(part),
          s = s - 1,
          e = i - 1
        })
        part = {}
        s = i + 1
      end
    else
      table.insert(part, c)
    end
    i = i + 1
  end

  if #part then
    table.insert(parsed, {
      text = table.concat(part),
      s = s - 1,
      e = i - 1
    })
    return parsed
  end

  table.insert(parsed, {
    text = '',
    s = #cmdline,
    e = #cmdline + 1
  })

  return parsed
end

return Command
