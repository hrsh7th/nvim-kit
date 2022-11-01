import fs from 'fs';
import dedent from 'ts-dedent';
import * as MetaModel from '../tmp/language-server-protocol/_specifications/lsp/3.18/metaModel/metaModel';
import metaModel from '../tmp/language-server-protocol/_specifications/lsp/3.18/metaModel/metaModel.json';

(() => {
  const definitions = dedent`
    local LSP = {}

    ${generate(metaModel as unknown as MetaModel.MetaModel)}

    return LSP;
  `;;
  fs.writeFileSync(`${__dirname}/../lua/___plugin_name___/kit/LSP/init.lua`, definitions, 'utf-8');
})();

function generate(metaModel: MetaModel.MetaModel) {
  return dedent`
    ${metaModel.enumerations.map(enums => {
      return generateEnum(enums);
    }).join('\n\n').trim()}

    ${metaModel.structures.map(struct => {
      return generateStruct(struct);
    }).join('\n\n').trim()}

    ${metaModel.typeAliases.map(alias => {
      return generateAlias(alias);
    }).join('\n\n').trim()}
  `;
}

function generateEnum(enums: MetaModel.Enumeration) {
  return dedent`
    ---@enum ${toPackageName(enums.name)}
    LSP.${enums.name} = {
      ${enums.values.map((value: typeof enums.values[number]) => {
        const typeNotation = toTypeNotation(enums.type);
        if (typeNotation === 'string') {
          return `  ${escapeKeyword(value.name)} = ${JSON.stringify(value.value)},`;
        } else if (typeNotation === 'integer') {
          return `  ${escapeKeyword(value.name)} = ${value.value},`;
        } else {
          throw new Error(`Invalid enumeration type: ${enums.type.name}`);
        }
      }).join('\n').trim()}
    }
  `;
}

function generateStruct(struct: MetaModel.Structure) {
  const extend = ((extends_: MetaModel.Structure['extends']) => {
    const extend = extends_?.[0];
    if (extend?.kind !== 'reference') {
      return '';
    }
    return dedent` : ${toPackageName(extend.name)}`;
  })(struct.extends);

  return dedent`
    ---@class ${toPackageName(struct.name)}${extend}
    ${struct.properties.map((prop: typeof struct.properties[number]) => {
      return `---@field public ${prop.name} ${toTypeNotation(prop.type)}`;
    }).join('\n').trim()}
  `;
}

function generateAlias(alias: MetaModel.TypeAlias) {
  return dedent`
    ---@alias ${toPackageName(alias.name)} ${toTypeNotation(alias.type)}
  `;
}

function toPackageName(name: string) {
  return `___plugin_name___.kit.LSP.${name}`;
}

function toTypeNotation(type: MetaModel.Type): string {
  if (type.kind === 'base') {
    return ({
      DocumentUri: 'string',
      null: 'nil',
      uinteger: 'integer',
      integer: 'integer',
      decimal: 'integer',
      string: 'string',
      boolean: 'boolean',
      RegExp: 'string',
      URI: 'string',
    } as Record<MetaModel.BaseTypes, string>)[type.name];
  } else if (type.kind === 'reference') {
    return toPackageName(type.name);
  } else if (type.kind === 'array') {
    return `${toTypeNotation(type.element)}[]`;
  } else if (type.kind === 'tuple') {
    return `(${type.items.map(toTypeNotation).join(' | ')})[]`;
  } else if (type.kind === 'literal') {
    return `{ ${type.value.properties.map(prop => {
      return `${prop.name}${prop.optional ? '?' : ''}: ${toTypeNotation(prop.type)}`;
    }).join(', ')} }`;
  } else if (type.kind === 'booleanLiteral') {
    return type.value ? 'true' : 'false';
  } else if (type.kind === 'stringLiteral') {
    return JSON.stringify(type.value);
  } else if (type.kind === 'integerLiteral') {
    return type.value.toString();
  } else if (type.kind === 'and') {
    console.log('We can\'t support `and` kind.');
    return '';
  } else if (type.kind === 'or') {
    return `(${type.items.map(toTypeNotation).join(' | ')})`;
  } else if (type.kind === 'map') {
    return `table<${toTypeNotation(type.key)}, ${toTypeNotation(type.value)}>`;
  }
  throw new Error(`Invalid type: ${JSON.stringify(type)}`);
}

function escapeKeyword(field: string) {
  return ({
    'function': "['function']",
    'local': "['local']",
  })[field] ?? field;
}
