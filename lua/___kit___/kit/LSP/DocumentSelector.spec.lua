local DocumentSelector = require('___kit___.kit.LSP.DocumentSelector')

-- @see https://github.com/microsoft/vscode/blob/7241eea61021db926c052b657d577ef0d98f7dc7/src/vs/editor/test/common/modes/languageSelector.test.ts
describe('kit.LSP.DocumentSelector', function()
  before_each(function()
    vim.cmd(([[
      e ./fixture/LSP/DocumentSelector/dummy.js
      set filetype=javascript
    ]]))
  end)

  it('score, any language', function()
    assert.equals(DocumentSelector.score(vim.api.nvim_get_current_buf(), { { language = 'javascript' } }), 10);
    assert.equals(DocumentSelector.score(vim.api.nvim_get_current_buf(), { { language = '*' } }), 5);
  end)

  it('score, default schemes', function()
    assert.equals(DocumentSelector.score(vim.api.nvim_get_current_buf(), { { scheme = 'file' } }), 10);
    assert.equals(DocumentSelector.score(vim.api.nvim_get_current_buf(), { { scheme = '*' } }), 5);
    assert.equals(DocumentSelector.score(vim.api.nvim_get_current_buf(), { { language = 'javascript', scheme = 'file' } }), 10);
    assert.equals(DocumentSelector.score(vim.api.nvim_get_current_buf(), { { language = 'javascript', scheme = '*' } }), 10);
    assert.equals(DocumentSelector.score(vim.api.nvim_get_current_buf(), { { language = 'javascript', scheme = '' } }), 10);
  end)

  it('score, filter', function()
    assert.equals(DocumentSelector.score(vim.api.nvim_get_current_buf(), { { pattern = '**/*.js' } }), 10);
    assert.equals(DocumentSelector.score(vim.api.nvim_get_current_buf(), { { pattern = '**/*.js', scheme = 'file' } }), 10);
    assert.equals(DocumentSelector.score(vim.api.nvim_get_current_buf(), { { pattern = '**/*.js', scheme = 'http' } }), 0);
    assert.equals(DocumentSelector.score(vim.api.nvim_get_current_buf(), { { pattern = '**/*.ts' } }), 0);
    assert.equals(DocumentSelector.score(vim.api.nvim_get_current_buf(), { { pattern = '**/*.ts', scheme = 'file' } }), 0);
  end)
end)
