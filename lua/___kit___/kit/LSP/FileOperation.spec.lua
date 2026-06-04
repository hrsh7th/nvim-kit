---@diagnostic disable: duplicate-set-field

local LSP = require('___kit___.kit.LSP')
local FileOperation = require('___kit___.kit.LSP.FileOperation')

local tmp = '/tmp/nvim-kit-file-operation-test'

---@param config { server_capabilities?: table, responses?: table<string, any> }
---@return table, { requests: { method: string, params: table }[], notifications: { method: string, params: table }[] }
local function create_mock_lsp_client(config)
  local recorded = { requests = {}, notifications = {} }
  local mock = {
    server_capabilities = config.server_capabilities or {},
    offset_encoding = 'utf-16',
  }

  function mock:request(method, params, callback)
    table.insert(recorded.requests, { method = method, params = params })
    vim.schedule(function()
      callback(nil, config.responses and config.responses[method] or nil)
    end)
    return true, #recorded.requests
  end

  function mock:cancel_request() end

  function mock:notify(method, params)
    table.insert(recorded.notifications, { method = method, params = params })
  end

  function mock:_registration_provider() return nil end

  function mock:_get_registrations() return {} end

  return mock, recorded
end

---@param mock table
---@param fn fun()
local function with_mock_client(mock, fn)
  local orig = vim.lsp.get_clients
  vim.lsp.get_clients = function() return { mock } end
  local ok, err = pcall(fn)
  vim.lsp.get_clients = orig
  if not ok then error(err, 2) end
end

---@param name string
---@param kind ___kit___.kit.LSP.FileOperationPatternKind
local function file_op_caps(name, kind)
  return {
    [name] = {
      filters = { {
        pattern = {
          glob = '**/*',
          matches = kind,
        },
      } },
    },
  }
end

describe('kit.LSP.FileOperation', function()
  before_each(function()
    vim.fn.delete(tmp, 'rf')
    vim.fn.mkdir(tmp, 'p')
  end)

  after_each(function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      local name = vim.api.nvim_buf_get_name(bufnr)
      if vim.startswith(name, tmp) or vim.startswith(name, vim.fn.resolve(tmp)) then
        pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
      end
    end
    vim.fn.delete(tmp, 'rf')
  end)

  describe('.create', function()
    it('creates a file with parent directories', function()
      local path = tmp .. '/a/b/c.lua'
      FileOperation.create({ { path = path, kind = LSP.FileOperationPatternKind.file } }):sync(5000)
      assert.equal(1, vim.fn.filereadable(path))
    end)

    it('creates a directory', function()
      local path = tmp .. '/new_dir'
      FileOperation.create({ { path = path, kind = LSP.FileOperationPatternKind.folder } }):sync(5000)
      assert.equal(1, vim.fn.isdirectory(path))
    end)

    it('sends willCreateFiles and didCreateFiles', function()
      local path = tmp .. '/file.lua'
      local mock, recorded = create_mock_lsp_client({
        server_capabilities = {
          workspace = {
            fileOperations = {
              willCreate = { filters = { { pattern = { glob = '**/*' } } } },
              didCreate  = { filters = { { pattern = { glob = '**/*' } } } },
            }
          },
        },
      })
      with_mock_client(mock, function()
        FileOperation.create({ { path = path, kind = LSP.FileOperationPatternKind.file } }):sync(5000)
      end)
      assert.equal(1, #recorded.requests)
      assert.equal('workspace/willCreateFiles', recorded.requests[1].method)
      assert.equal(1, #recorded.notifications)
      assert.equal('workspace/didCreateFiles', recorded.notifications[1].method)
    end)
  end)

  describe('.delete', function()
    it('deletes a file', function()
      local path = tmp .. '/to_delete.lua'
      vim.fn.writefile({}, path)
      FileOperation.delete({ { path = path, kind = LSP.FileOperationPatternKind.file } }):sync(5000)
      assert.equal(0, vim.fn.filereadable(path))
    end)

    it('deletes a directory recursively', function()
      local path = tmp .. '/dir_to_delete'
      vim.fn.mkdir(path, 'p')
      vim.fn.writefile({}, path .. '/file.lua')
      FileOperation.delete({ { path = path, kind = LSP.FileOperationPatternKind.folder } }):sync(5000)
      assert.equal(0, vim.fn.isdirectory(path))
    end)

    it('sends willDeleteFiles and didDeleteFiles', function()
      local path = tmp .. '/to_delete.lua'
      vim.fn.writefile({}, path)
      local mock, recorded = create_mock_lsp_client({
        server_capabilities = {
          workspace = {
            fileOperations = {
              willDelete = { filters = { { pattern = { glob = '**/*' } } } },
              didDelete  = { filters = { { pattern = { glob = '**/*' } } } },
            }
          },
        },
      })
      with_mock_client(mock, function()
        FileOperation.delete({ { path = path, kind = LSP.FileOperationPatternKind.file } }):sync(5000)
      end)
      assert.equal(1, #recorded.requests)
      assert.equal('workspace/willDeleteFiles', recorded.requests[1].method)
      assert.equal(1, #recorded.notifications)
      assert.equal('workspace/didDeleteFiles', recorded.notifications[1].method)
    end)
  end)

  describe('.rename', function()
    it('moves a file', function()
      local old = tmp .. '/old.lua'
      local new = tmp .. '/new.lua'
      vim.fn.writefile({}, old)
      FileOperation.rename({ { path = old, path_new = new, kind = LSP.FileOperationPatternKind.file } }):sync(5000)
      assert.equal(0, vim.fn.filereadable(old))
      assert.equal(1, vim.fn.filereadable(new))
    end)

    it('sends willRenameFiles and didRenameFiles with correct URIs', function()
      local old = tmp .. '/old.lua'
      local new = tmp .. '/new.lua'
      vim.fn.writefile({}, old)
      local mock, recorded = create_mock_lsp_client({
        server_capabilities = {
          workspace = {
            fileOperations = {
              willRename = { filters = { { pattern = { glob = '**/*' } } } },
              didRename  = { filters = { { pattern = { glob = '**/*' } } } },
            }
          },
        },
      })
      with_mock_client(mock, function()
        FileOperation.rename({ { path = old, path_new = new, kind = LSP.FileOperationPatternKind.file } }):sync(5000)
      end)
      assert.equal(1, #recorded.requests)
      assert.equal('workspace/willRenameFiles', recorded.requests[1].method)
      assert.same(
        { oldUri = vim.uri_from_fname(old), newUri = vim.uri_from_fname(new) },
        recorded.requests[1].params.files[1]
      )
      assert.equal(1, #recorded.notifications)
      assert.equal('workspace/didRenameFiles', recorded.notifications[1].method)
    end)

    it('file filter does not match folder operation', function()
      local old = tmp .. '/dir'
      local new = tmp .. '/dir_new'
      vim.fn.mkdir(old, 'p')
      local mock, recorded = create_mock_lsp_client({
        server_capabilities = {
          workspace = {
            fileOperations = {
              willRename = file_op_caps('willRename', LSP.FileOperationPatternKind.file).willRename,
              didRename  = file_op_caps('didRename', LSP.FileOperationPatternKind.file).didRename,
            }
          },
        },
      })
      with_mock_client(mock, function()
        FileOperation.rename({ { path = old, path_new = new, kind = LSP.FileOperationPatternKind.folder } }):sync(5000)
      end)
      assert.equal(0, #recorded.requests)
      assert.equal(0, #recorded.notifications)
    end)

    it('folder glob with trailing slash matches directory via path/ fallback', function()
      local old = tmp .. '/dir'
      local new = tmp .. '/dir_new'
      vim.fn.mkdir(old, 'p')
      local mock, recorded = create_mock_lsp_client({
        server_capabilities = {
          workspace = {
            fileOperations = {
              willRename = {
                filters = { {
                  pattern = {
                    glob = '**/',
                    matches = LSP.FileOperationPatternKind.folder,
                  },
                } },
              },
              didRename = {
                filters = { {
                  pattern = {
                    glob = '**/',
                    matches = LSP.FileOperationPatternKind.folder,
                  },
                } },
              },
            }
          },
        },
      })
      with_mock_client(mock, function()
        FileOperation.rename({ { path = old, path_new = new, kind = LSP.FileOperationPatternKind.folder } }):sync(5000)
      end)
      assert.equal(1, #recorded.requests)
      assert.equal('workspace/willRenameFiles', recorded.requests[1].method)
      assert.equal(1, #recorded.notifications)
      assert.equal('workspace/didRenameFiles', recorded.notifications[1].method)
    end)

    it('folder filter does not match file operation', function()
      local old = tmp .. '/old.lua'
      local new = tmp .. '/new.lua'
      vim.fn.writefile({}, old)
      local mock, recorded = create_mock_lsp_client({
        server_capabilities = {
          workspace = {
            fileOperations = {
              willRename = file_op_caps('willRename', LSP.FileOperationPatternKind.folder).willRename,
              didRename  = file_op_caps('didRename', LSP.FileOperationPatternKind.folder).didRename,
            }
          },
        },
      })
      with_mock_client(mock, function()
        FileOperation.rename({ { path = old, path_new = new, kind = LSP.FileOperationPatternKind.file } }):sync(5000)
      end)
      assert.equal(0, #recorded.requests)
      assert.equal(0, #recorded.notifications)
    end)

    it('applies WorkspaceEdit before physical rename', function()
      local old = tmp .. '/old.lua'
      local new = tmp .. '/new.lua'
      vim.fn.writefile({ 'hello' }, old)

      local file_existed_at_apply_time = nil
      local mock, _ = create_mock_lsp_client({
        server_capabilities = {
          workspace = {
            fileOperations = {
              willRename = { filters = { { pattern = { glob = '**/*' } } } },
            }
          },
        },
        responses = {
          ['workspace/willRenameFiles'] = {
            changes = {
              [vim.uri_from_fname(old)] = {
                { newText = 'world', range = { start = { line = 0, character = 0 }, ['end'] = { line = 0, character = 5 } } },
              },
            },
          },
        },
      })
      -- Intercept apply_workspace_edit to record whether old file still exists.
      local orig = vim.lsp.util.apply_workspace_edit
      vim.lsp.util.apply_workspace_edit = function(edit, encoding)
        file_existed_at_apply_time = vim.fn.filereadable(old) == 1
        orig(edit, encoding)
      end
      with_mock_client(mock, function()
        FileOperation.rename({ { path = old, path_new = new, kind = LSP.FileOperationPatternKind.file } }):sync(5000)
      end)
      vim.lsp.util.apply_workspace_edit = orig

      assert.is_true(file_existed_at_apply_time)
    end)

    it('updates buffer name on file rename', function()
      local old = tmp .. '/old.lua'
      local new = tmp .. '/new.lua'
      vim.fn.writefile({ 'hello' }, old)
      local bufnr = vim.fn.bufadd(old)
      vim.fn.bufload(bufnr)

      FileOperation.rename({ { path = old, path_new = new, kind = LSP.FileOperationPatternKind.file } }):sync(5000)

      assert.equal(vim.fn.resolve(vim.fs.normalize(new)), vim.fn.resolve(vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))))
    end)

    it('updates all buffer names under a renamed directory', function()
      local old_dir = tmp .. '/dir'
      local new_dir = tmp .. '/dir_renamed'
      vim.fn.mkdir(old_dir, 'p')
      local file_a = old_dir .. '/a.lua'
      local file_b = old_dir .. '/sub/b.lua'
      vim.fn.mkdir(old_dir .. '/sub', 'p')
      vim.fn.writefile({}, file_a)
      vim.fn.writefile({}, file_b)
      local buf_a = vim.fn.bufadd(file_a)
      local buf_b = vim.fn.bufadd(file_b)
      vim.fn.bufload(buf_a)
      vim.fn.bufload(buf_b)

      FileOperation.rename({ { path = old_dir, path_new = new_dir, kind = LSP.FileOperationPatternKind.folder } }):sync(5000)

      assert.equal(vim.fn.resolve(vim.fs.normalize(new_dir .. '/a.lua')), vim.fn.resolve(vim.fs.normalize(vim.api.nvim_buf_get_name(buf_a))))
      assert.equal(vim.fn.resolve(vim.fs.normalize(new_dir .. '/sub/b.lua')), vim.fn.resolve(vim.fs.normalize(vim.api.nvim_buf_get_name(buf_b))))
    end)
  end)
end)
