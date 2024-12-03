-- luacheck: ignore 311
local kit = require('___kit___.kit')
local Async = require('___kit___.kit.Async')

describe('kit', function()
  describe('debounce', function()
    it('should callback after timeout', function()
      Async.run(function()
        local count = 0
        local fn = kit.debounce(function()
          count = count + 1
        end, 200)
        fn()
        assert.are.equals(count, 0)
        fn()
        assert.are.equals(count, 0)
        vim.wait(200)
        assert.are.equals(count, 1)
        fn()
        fn()
        assert.are.equals(count, 1)
        vim.wait(200)
        assert.are.equals(count, 2)
        vim.wait(200)
        assert.are.equals(count, 2)
      end):sync(5000)
    end)
  end)

  describe('throttle', function()
    it('should callback after timeout', function()
      Async.run(function()
        local count = 0
        local throttled = kit.throttle(function()
          count = count + 1
        end, 200)
        throttled()
        assert.are.equals(count, 1)
        throttled()
        assert.are.equals(count, 1)
        vim.wait(200)
        assert.are.equals(count, 2)
        throttled()
        throttled()
        assert.are.equals(count, 2)
        vim.wait(200)
        assert.are.equals(count, 3)
        vim.wait(200)
        assert.are.equals(count, 3)
      end):sync(5000)
    end)
  end)

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
            k = vim.NIL,
          },
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
          j = {},
        }
      )
    end)
  end)

  describe('.concat', function()
    it('should concat', function()
      assert.are.same({ 1, 2, 3, 4, 5, 6 }, kit.concat({ 1, 2, 3 }, { 4, 5, 6 }))
    end)
    it('should concat nil contained list', function()
      assert.are.same({ 1, 3, 4, 6 }, kit.concat({ 1, nil, 3 }, { 4, nil, 6 }))
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
end)
