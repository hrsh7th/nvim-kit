local Event = require('___kit___.kit.App.Event')

local step = setmetatable({
  steps = {},
}, {
  __call = function(self, ...)
    table.insert(self.steps, { ... })
  end,
}) --[[@as function]]

describe('kit.App.Event', function()
  before_each(function()
    vim.cmd([[enew]])
  end)

  it('should work', function()
    local event = Event.new()
    event:on('e', function(...)
      step(1, ...)
    end)
    event:on('e', function(...)
      step(2, ...)
    end)
    event:on('e', function(...)
      step(3, ...)
    end)
    event:once('e', function(...)
      step(4, ...)
    end)
    event:on('e', function(...)
      step(5, ...)
    end)()

    event:emit('e', 'payload1')
    event:emit('e', 'payload2')
    assert.are.same(step.steps, {
      { 1, 'payload1' },
      { 2, 'payload1' },
      { 3, 'payload1' },
      { 4, 'payload1' },
      { 1, 'payload2' },
      { 2, 'payload2' },
      { 3, 'payload2' },
    })
  end)
end)
