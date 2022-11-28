import fs from 'fs';
import dedent from 'ts-dedent';
import { generateAlias, generateEnum, generateStruct, method2type } from '.';
import * as MetaModel from '../../tmp/language-server-protocol/_specifications/lsp/3.18/metaModel/metaModel';
import metaModel from '../../tmp/language-server-protocol/_specifications/lsp/3.18/metaModel/metaModel.json';

(() => {
  const definitions = dedent`
    local LSP = {}

    ${generate(metaModel as unknown as MetaModel.MetaModel)}

    return LSP
  `;;
  fs.writeFileSync(`${__dirname}/../../lua/___kit___/kit/LSP/init.lua`, definitions, 'utf-8');
})();

/**
 * Generate all type definitions.
 */
function generate(metaModel: MetaModel.MetaModel) {
  return dedent`
  ${metaModel.enumerations.map(enums => {
    return generateEnum(enums);
  }).join('\n\n').trim()}

  ${metaModel.structures.map(struct => {
    return generateStruct(struct);
  }).join('\n\n').trim()}

  ${metaModel.requests.map(request => {
    return generateAlias({
      name: method2type(request.method),
      type: request.result,
    });
  }).join('\n\n').trim()}

  ${metaModel.typeAliases.map(alias => {
    return generateAlias(alias);
  }).join('\n\n').trim()}
  `;
}

