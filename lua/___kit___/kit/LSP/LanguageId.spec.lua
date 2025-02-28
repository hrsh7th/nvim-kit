local LanguageId = require('___kit___.kit.LSP.LanguageId')

describe('kit.LSP.LanguageId', function()
  it('mapping', function()
    assert.equal(LanguageId.from_filetype('sh'), 'shellscript')
    assert.equal(LanguageId.from_filetype('javascript.tsx'), 'javascriptreact')
    assert.equal(LanguageId.from_filetype('typescript.tsx'), 'typescriptreact')
  end)
end)
