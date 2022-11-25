local kit = require('___kit___.kit')
local Async = require('___kit___.kit.Async')
local AsyncTask = require('___kit___.kit.Async.AsyncTask')

local Highlight = {}

Highlight.namespace = vim.api.nvim_create_namespace('___kit___.kit.Vim.Highlight')

---Blink specified range.
---@param range ___kit___.kit.LSP.Range
---@param option? { delay: integer, count: integer }
---@return ___kit___.kit.Async.AsyncTask
function Highlight.blink(range, option)
  option = kit.merge(option or {}, {
    delay = 150,
    count = 2,
  })

  local function timeout(time)
    return AsyncTask.new(function(resolve)
      vim.defer_fn(vim.schedule_wrap(resolve), time)
    end)
  end

  return Async.run(function()
    timeout(option.delay * 1.2):await()
    for _ = 1, option.count do
      vim.highlight.range(0, Highlight.namespace, 'IncSearch', { range.start.line, range.start.character }, { range['end'].line, range['end'].character }, {})
      timeout(option.delay * 0.8):await()
      vim.api.nvim_buf_clear_namespace(0, Highlight.namespace, 0, -1)
      timeout(option.delay):await()
    end
  end)
end

return Highlight
