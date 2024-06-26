-- luacheck: ignore 311
local kit = require('___kit___.kit')

describe('kit', function()
  describe('.gc', function()
    it('should detect gc timing.', function()
      local called = false
      local object = {
        marker = kit.gc(function()
          called = true
        end),
      }
      object = nil
      collectgarbage('collect')
      vim.wait(200, function()
        return object
      end)
      assert.are.equals(object, nil)
      assert.are.equals(called, true)
    end)
  end)
  describe('.{pack,unpack}', function()
    it('should pack and unpack', function()
      local source = {
        call_count = 0,
      }
      function source:call()
        self.call_count = self.call_count + 1
        return self.call_count
      end

      local unpacked = kit.unpack(kit.pack(source))
      assert.are.equals(unpacked.call_count, 0)
      assert.are.equals(unpacked:call(), 1)
      assert.are.equals(unpacked:call(), 2)
      assert.are.equals(unpacked.call_count, 2)
    end)
  end)
  describe('.merge', function()
    it('should merge two dict', function()
      assert.are.same(
        kit.merge({
          a = true,
          b = {
            c = vim.NIL,
          },
          d = {
            e = 3,
          },
          h = false,
          i = { 1, 2, 3 },
          j = {
            k = vim.NIL
          }
        }, {
          a = false,
          b = {
            c = true,
          },
          d = {
            f = {
              g = vim.NIL,
            },
          },
          i = { 2, 3, 4 },
        }),
        {
          a = true,
          b = {},
          d = {
            e = 3,
            f = {},
          },
          h = false,
          i = { 1, 2, 3 },
          j = {}
        }
      )
    end)
  end)

  describe('.map', function()
    it('should map values', function()
      local function to_index(_, i)
        return i
      end
      assert.are.same(kit.map({ 0, 0, 0 }, to_index), { 1, 2, 3 })
    end)
  end)

  describe('.concat', function()
    it('should concat two list', function()
      assert.are.same(kit.concat({ 1, 2, 3 }, { 4, 5, 6 }), { 1, 2, 3, 4, 5, 6 })
    end)
  end)

  describe('.to_array', function()
    it('should convert value to array', function()
      assert.are.same(kit.to_array(1), { 1 })
      assert.are.same(kit.to_array({ 1, 2, 3 }), { 1, 2, 3 })
      assert.are.same(kit.to_array({}), {})
      assert.are.same(kit.to_array({ a = 1 }), { { a = 1 } })
    end)
  end)

  describe('.is_array', function()
    it('should check array or not', function()
      assert.are.equal(kit.is_array({}), true)
      assert.are.equal(kit.is_array({ 1 }), true)
      assert.are.equal(kit.is_array({ a = 1 }), false)
      assert.are.equal(kit.is_array({ 1, a = 1 }), false)
      assert.are.equal(kit.is_array(1), false)
    end)
  end)

  describe('.is_dict', function()
    it('should check array or not', function()
      assert.are.equal(kit.is_dict({}), true)
      assert.are.equal(kit.is_dict({ 1 }), false)
      assert.are.equal(kit.is_dict({ a = 1 }), true)
      assert.are.equal(kit.is_dict({ 1, a = 1 }), true)
      assert.are.equal(kit.is_dict(1), false)
    end)
  end)

  describe('.reverse', function()
    it('should reverse the array', function()
      assert.are.same(kit.reverse({ 1, 2, 3 }), { 3, 2, 1 })
    end)
  end)

  describe('.default', function()
    it('should return default value', function()
      assert.are.equal(kit.default(nil, 1), 1)
      assert.are.equal(kit.default(false, {}), false)
      assert.are.equal(kit.default(2, 1), 2)
    end)
  end)

  describe('.get', function()
    it('should return value of the paths', function()
      assert.are.equal(kit.get({ a = false }, { 'a' }, true), false)
      assert.are.equal(kit.get({ a = { b = 1 } }, { 'a', 'b' }), 1)
      assert.are.equal(kit.get({ a = { b = 1 } }, { 'a', 'c' }), nil)
      assert.are.equal(kit.get({ a = { b = 1 } }, { 'a', 'c' }, 2), 2)
      assert.are.equal(kit.get({ a = { b = { 1 } } }, { 'a', 'b', 1 }), 1)
      assert.are.equal(kit.get({ a = { b = { 1 } } }, { 'a', 'b', 2 }), nil)
    end)
  end)
end)
