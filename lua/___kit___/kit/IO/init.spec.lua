local IO = require('___kit___.kit.IO')

local tmpdir = '/tmp/nvim-kit/IO'

describe('kit.IO', function()
  describe('.walk', function()
    it('should walk directory entires (preorder)', function()
      local entries = {}
      IO.walk('./fixture/IO/scandir/a', function(_, entry)
        table.insert(entries, entry)
      end):sync(5000)
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
      end, { postorder = true }):sync(5000)
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
    it('should break if found specified path (pre)', function()
      local count = 0
      IO.walk('./fixture/IO/scandir/a', function(_, entry)
        count = count + 1
        if IO.normalize('./fixture/IO/scandir/a/1') == entry.path then
          return IO.WalkStatus.Break
        end
      end):sync(5000)
      assert.equal(count, 4)
    end)
    it('should break if found specified path (post)', function()
      local count = 0
      IO.walk('./fixture/IO/scandir/a', function(_, entry)
        count = count + 1
        if IO.normalize('./fixture/IO/scandir/a/1') == entry.path then
          return IO.WalkStatus.Break
        end
      end, { postorder = true }):sync(5000)
      assert.equal(count, 3)
    end)
  end)

  describe('.read_file', function()
    it('should read the file', function()
      assert.are.equal(
        IO.read_file('./fixture/IO/read_file.txt', 5):sync(5000),
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
      if IO.stat('./fixture/IO/write_file.txt'):catch(function() end):sync(5000) then
        IO.rm('./fixture/IO/write_file.txt'):sync(5000)
      end
      IO.write_file('./fixture/IO/write_file.txt', IO.read_file('./fixture/IO/read_file.txt', 5):sync(5000))
      local contents1 = IO.read_file('./fixture/IO/read_file.txt', 5):sync(5000)
      local contents2 = IO.read_file('./fixture/IO/write_file.txt', 5):sync(5000)
      assert.are.equal(#contents1, #contents2)
      IO.rm('./fixture/IO/write_file.txt'):sync(5000)
    end)
  end)

  describe('.scandir', function()
    it('should return entries', function()
      local entries = IO.scandir('./fixture/IO/scandir/a'):sync(5000)
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
      IO.cp('./fixture/IO/scandir/a', './fixture/IO/scandir/b', { recursive = true }):sync(5000)
      assert.is_true(IO.is_directory('./fixture/IO/scandir/b'):sync(5000))
      IO.rm('./fixture/IO/scandir/b', { recursive = true }):sync(5000)
    end)
  end)

  describe('.rm', function()
    it('should remove dir or file', function()
      local target_dir = tmpdir .. '/rm'
      if not IO.is_directory(target_dir):sync(5000) then
        IO.mkdir(target_dir, tonumber('777', 8), { recursive = true }):sync(5000)
      end
      assert.is_true(IO.is_directory(target_dir):sync(5000))
      IO.rm(target_dir, { recursive = true }):sync(5000)
      assert.is_false(IO.is_directory(target_dir):sync(5000))
    end)
  end)

  describe('.mkdir', function()
    it('should create dir', function()
      local target_dir = tmpdir .. '/mkdir'
      if IO.is_directory(target_dir):sync(5000) then
        IO.rm(target_dir, { recursive = true }):sync(5000)
      end
      assert.is_false(IO.is_directory(target_dir):sync(5000))
      IO.mkdir(target_dir, tonumber('777', 8), { recursive = true }):sync(5000)
      assert.is_true(IO.is_directory(target_dir):sync(5000))
    end)
  end)

  describe('.join', function()
    it('should join paths', function()
      assert.are.equal(IO.join('a', 'b', 'c'), 'a/b/c')
    end)
    it('should handle current directory pattern prefix', function()
      assert.are.equal(IO.join('a/b/c', './d', './e'), 'a/b/c/d/e')
    end)
    it('should handle parent directory pattern prefixes', function()
      assert.are.equal(IO.join('a/b/c', '../d'), 'a/b/d')
      assert.are.equal(IO.join('a/b/c', '../../d'), 'a/d')
      assert.are.equal(IO.join('a/b/c', '../d', '../../e'), 'a/e')
    end)
  end)
end)
