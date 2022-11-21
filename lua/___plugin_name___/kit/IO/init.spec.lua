local IO = require('___plugin_name___.kit.IO')

local tmpdir = '/tmp/nvim-kit/IO'

describe('kit.IO', function()
  describe('.read_file', function()
    it('should read the file', function()
      assert.are.equals(IO.read_file('./fixture/IO/read_file.txt', 5):sync(), table.concat({
        'read_file',
        'read_file',
        'read_file',
        'read_file',
        'read_file',
        'read_file',
        'read_file',
        'read_file',
        'read_file',
        'read_file',
      }, '\n'))
    end)
  end)

  describe('.write_file', function()
    it('should write the file', function()
      pcall(function()
        IO.rm('./fixture/IO/write_file.txt'):sync()
      end)
      IO.write_file(
        './fixture/IO/write_file.txt',
        IO.read_file('./fixture/IO/read_file.txt', 5):sync()
      )
      local contents1 = IO.read_file('./fixture/IO/read_file.txt', 5):sync()
      local contents2 = IO.read_file('./fixture/IO/write_file.txt', 5):sync()
      assert.are.equals(#contents1, #contents2)
      IO.rm('./fixture/IO/write_file.txt'):sync()
    end)
  end)

  describe('.scandir', function()
    it('should return entries', function()
      local entries = IO.scandir('./fixture/IO/scandir/a'):sync()
      table.sort(entries, function(a, b)
        return a.path < b.path
      end)
      assert.are.same({
        {
          path = IO.normalize('./fixture/IO/scandir/a/0'),
          type = 'directory',
        },
        {
          path = IO.normalize('./fixture/IO/scandir/a/1'),
          type = 'file',
        },
        {
          path = IO.normalize('./fixture/IO/scandir/a/2'),
          type = 'file',
        },
        {
          path = IO.normalize('./fixture/IO/scandir/a/3'),
          type = 'file',
        },
      }, entries)
    end)
  end)

  describe('.cp', function()
    it('should copy directory recursively', function()
      IO.cp('./fixture/IO/scandir/a', './fixture/IO/scandir/b', { recursive = true }):sync()
      assert.is_true(vim.fn.isdirectory('./fixture/IO/scandir/b') == 1)
      IO.rm('./fixture/IO/scandir/b', { recursive = true }):sync()
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
