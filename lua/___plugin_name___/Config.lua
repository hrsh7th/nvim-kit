local kit = require('___plugin_name___')
local Cache = require('___plugin_name___.Cache')

---@class kit.Config
---@field private cache kit.Cache
---@field private global table
---@field private filetype table<string, table>
---@field private buffer table<number, table>
local Config = {}

---Create new config instance.
---@retrn kit.Config
function Config.new()
  local self = setmetatable({}, { __index = Config })
  self.cache = Cache.new()
  self.global = {}
  self.filetype = {}
  self.buffer = {}
  return self
end

---Update global config.
---@param config table
function Config:setup_global(config)
  local revision = (self.global.revision or 1) + 1
  self.global = config or {}
  self.global.revision = revision
end

---Update filetype config.
---@param filetype string
---@param config table
function Config:setup_filetype(filetype, config)
  local revision = ((self.filetype[filetype] or {}).revision or 1) + 1
  self.filetype[filetype] = config or {}
  self.filetype[filetype].revision = revision
end

---Update filetype config.
---@param bufnr number
---@param config table
function Config:setup_buffer(bufnr, config)
  bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
  local revision = ((self.buffer[bufnr] or {}).revision or 1) + 1
  self.buffer[bufnr] = config or {}
  self.buffer[bufnr].revision = revision
end

---Get current configuration.
---@return table
function Config:get()
  local filetype = vim.api.nvim_buf_get_option(0, 'filetype')
  local bufnr = vim.api.nvim_get_current_buf()
  return self.cache:ensure({
    self.global.revision or 0,
    (self.buffer[bufnr] or {}).revision or 0,
    (self.filetype[filetype] or {}).revision or 0
  }, function()
    local config
    config = self.global
    config = kit.merge(self.filetype[filetype] or {}, config)
    config = kit.merge(self.buffer[bufnr] or {}, config)
    config.revision = nil
    return config
  end)
end

return Config

