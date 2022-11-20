local IO = require('___plugin_name___.kit.IO')

local tmpdir = '/tmp/nvim-kit/IO'

describe('kit.Lua.IO', function()
  describe('.ls', function()
    it('should return entries', function()
      local entries = IO.ls('./fixture/Lua/IO/a'):sync()
      table.sort(entries, function(a, b)
        return a.path < b.path
      end)
      assert.are.same({
        {
          path = IO.normalize('./fixture/Lua/IO/a/0'),
          type = 'directory',
        },
        {
          path = IO.normalize('./fixture/Lua/IO/a/1'),
          type = 'file',
        },
        {
          path = IO.normalize('./fixture/Lua/IO/a/2'),
          type = 'file',
        },
        {
          path = IO.normalize('./fixture/Lua/IO/a/3'),
          type = 'file',
        },
      }, entries)
    end)
  end)

  describe('.cp', function()
    it('should copy directory recursively', function()
      IO.cp('./fixture/Lua/IO/a', './fixture/Lua/IO/b', { recursive = true }):sync()
      assert.is_true(vim.fn.isdirectory('./fixture/Lua/IO/b') == 1)

      local entries = IO.ls('./fixture/Lua/IO/b'):sync()
      table.sort(entries, function(a, b)
        return a.path < b.path
      end)
      assert.are.same({
        {
          path = IO.normalize('./fixture/Lua/IO/b/0'),
          type = 'directory',
        },
        {
          path = IO.normalize('./fixture/Lua/IO/b/1'),
          type = 'file',
        },
        {
          path = IO.normalize('./fixture/Lua/IO/b/2'),
          type = 'file',
        },
        {
          path = IO.normalize('./fixture/Lua/IO/b/3'),
          type = 'file',
        },
      }, entries)
      IO.rm('./fixture/Lua/IO/b', { recursive = true }):sync()
    end)
  end)

  describe('.rm', function()
    it('should remove dir or file', function()
      pcall(function()
        IO.mkdir(tmpdir .. '/mkdir', tonumber('777', 8), { recursive = true }):sync()
      end)
      assert.is_true(vim.fn.isdirectory(tmpdir) == 1)
      IO.rm(tmpdir, { recursive = true }):sync()
      assert.is_true(vim.fn.isdirectory(tmpdir) == 0)
    end)
  end)

  describe('.mkdir', function()
    it('should create dir', function()
      pcall(function()
        IO.rm(tmpdir, { recursive = true }):sync()
      end)
      assert.is_true(vim.fn.isdirectory(tmpdir) == 0)
      IO.mkdir(tmpdir, tonumber('777', 8), { recursive = true }):sync()
      assert.is_true(vim.fn.isdirectory(tmpdir) == 1)
    end)
  end)
end)
