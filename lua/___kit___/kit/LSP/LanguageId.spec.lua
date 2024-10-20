local LanguageId = require('___kit___.kit.LSP.LanguageId')

describe('kit.LSP.LanguageId', function()
  it('mapping', function()
    assert.equals(LanguageId.from_filetype('sh'), 'shellscript')
    assert.equals(LanguageId.from_filetype('javascript.tsx'), 'javascriptreact')
    assert.equals(LanguageId.from_filetype('typescript.tsx'), 'typescriptreact')
  end)
end)
