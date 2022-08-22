local kit = require('___plugin_name___')
local Cache = require('___plugin_name___.Cache')

---@class kit.Config
---@field private _cache kit.Cache
---@field private _global table
---@field private _filetype table<string, table>
---@field private _buffer table<number, table>
local Config = {}

---Create new config instance.
---@retrn kit.Config
function Config.new()
  local self = setmetatable({}, { __index = Config })
  self._cache = Cache.new()
  self._global = {}
  self._filetype = {}
  self._buffer = {}
  return self
end

---Update global config.
---@param config table
function Config:global(config)
  local revision = (self._global.revision or 1) + 1
  self._global = config or {}
  self._global.revision = revision
end

---Update filetype config.
---@param filetypes string|string[]
---@param config table
function Config:filetype(filetypes, config)
  for _, filetype in ipairs(kit.to_array(filetypes)) do
    local revision = ((self._filetype[filetype] or {}).revision or 1) + 1
    self._filetype[filetype] = config or {}
    self._filetype[filetype].revision = revision
  end
end

---Update filetype config.
---@param bufnr number
---@param config table
function Config:buffer(bufnr, config)
  bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
  local revision = ((self._buffer[bufnr] or {}).revision or 1) + 1
  self._buffer[bufnr] = config or {}
  self._buffer[bufnr].revision = revision
end

---Get current configuration.
---@return table
function Config:get()
  local filetype = vim.api.nvim_buf_get_option(0, 'filetype')
  local bufnr = vim.api.nvim_get_current_buf()
  return self._cache:ensure({
    self._global.revision or 0,
    (self._buffer[bufnr] or {}).revision or 0,
    (self._filetype[filetype] or {}).revision or 0
  }, function()
    local config
    config = self._global
    config = kit.merge(self._filetype[filetype] or {}, config)
    config = kit.merge(self._buffer[bufnr] or {}, config)
    config.revision = nil
    return config
  end)
end

return Config

