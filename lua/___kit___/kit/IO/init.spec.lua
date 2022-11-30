local IO = require('___kit___.kit.IO')

local tmpdir = '/tmp/nvim-kit/IO'

describe('kit.IO', function()
  describe('.walk', function()
    it('should walk directory entires (preorder)', function()
      local entries = {}
      IO.walk('./fixture/IO/scandir/a', function(_, entry)
        table.insert(entries, entry)
      end):sync()
      assert.are.same({
        {
          path = IO.normalize('./fixture/IO/scandir/a'),
          type = 'directory',
        },
        {
          path = IO.normalize('./fixture/IO/scandir/a/0'),
          type = 'directory',
        },
        {
          path = IO.normalize('./fixture/IO/scandir/a/0/1'),
          type = 'file',
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
    it('should walk directory entires (postorder)', function()
      local entries = {}
      IO.walk('./fixture/IO/scandir/a', function(_, entry)
        table.insert(entries, entry)
      end, { postorder = true }):sync()
      assert.are.same({
        {
          path = IO.normalize('./fixture/IO/scandir/a/0/1'),
          type = 'file',
        },
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
        {
          path = IO.normalize('./fixture/IO/scandir/a'),
          type = 'directory',
        },
      }, entries)
    end)
  end)

  describe('.read_file', function()
    it('should read the file', function()
      assert.are.equals(
        IO.read_file('./fixture/IO/read_file.txt', 5):sync(),
        table.concat({
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
        }, '\n')
      )
    end)
  end)

  describe('.write_file', function()
    it('should write the file', function()
      if IO.fs_stat('./fixture/IO/write_file.txt'):catch(function() end):sync() then
        IO.rm('./fixture/IO/write_file.txt'):sync()
      end
      IO.write_file('./fixture/IO/write_file.txt', IO.read_file('./fixture/IO/read_file.txt', 5):sync())
      local contents1 = IO.read_file('./fixture/IO/read_file.txt', 5):sync()
      local contents2 = IO.read_file('./fixture/IO/write_file.txt', 5):sync()
      assert.are.equals(#contents1, #contents2)
      IO.rm('./fixture/IO/write_file.txt'):sync()
    end)
  end)

  describe('.scandir', function()
    it('should return entries', function()
      local entries = IO.scandir('./fixture/IO/scandir/a'):sync()
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
      assert.is_true(IO.is_directory('./fixture/IO/scandir/b'):sync())
      IO.rm('./fixture/IO/scandir/b', { recursive = true }):sync()
    end)
  end)

  describe('.rm', function()
    it('should remove dir or file', function()
      local target_dir = tmpdir .. '/rm'
      if not IO.is_directory(target_dir):sync() then
        IO.mkdir(target_dir, tonumber('777', 8), { recursive = true }):sync()
      end
      assert.is_true(IO.is_directory(target_dir):sync())
      IO.rm(target_dir, { recursive = true }):sync()
      assert.is_false(IO.is_directory(target_dir):sync())
    end)
  end)

  describe('.mkdir', function()
    it('should create dir', function()
      local target_dir = tmpdir .. '/mkdir'
      if IO.is_directory(target_dir):sync() then
        IO.rm(target_dir, { recursive = true }):sync()
      end
      assert.is_false(IO.is_directory(target_dir):sync())
      IO.mkdir(target_dir, tonumber('777', 8), { recursive = true }):sync()
      assert.is_true(IO.is_directory(target_dir):sync())
    end)
  end)
end)
