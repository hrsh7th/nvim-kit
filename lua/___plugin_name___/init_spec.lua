local kit = require('___plugin_name___')

describe('kit', function()

  it('should merge two dict', function()
    assert.are.same(
      kit.merge({
        a = true,
        b = {
          c = vim.NIL,
        },
        d = {
          e = 3,
        }
      }, {
        a = false,
        b = {
          c = true,
        },
        d = {
          f = {
            g = vim.NIL
          }
        }
      }),
      {
        a = true,
        b = {
        },
        d = {
          e = 3,
          f = {}
        }
      }
    )
  end)

  it('should concat two list', function()
    assert.are.same(kit.concat({ 1, 2, 3 }, { 4, 5, 6 }), { 1, 2, 3, 4, 5, 6 })
  end)

end)
