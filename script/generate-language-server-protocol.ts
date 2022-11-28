import fs from 'fs';
import dedent from 'ts-dedent';
import * as MetaModel from '../tmp/language-server-protocol/_specifications/lsp/3.18/metaModel/metaModel';
import metaModel from '../tmp/language-server-protocol/_specifications/lsp/3.18/metaModel/metaModel.json';

(() => {
  const definitions = dedent`
    local LSP = {}

    ${generate(metaModel as unknown as MetaModel.MetaModel)}

    return LSP
  `;;
  fs.writeFileSync(`${__dirname}/../lua/___kit___/kit/LSP/init.lua`, definitions, 'utf-8');
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

    ${metaModel.typeAliases.map(alias => {
    return generateAlias(alias);
  }).join('\n\n').trim()}
  `;
}

/**
 * Generate enum definitions.
 */
function generateEnum(enums: MetaModel.Enumeration) {
  return dedent`
    ---@enum ${toPackageName(enums.name)}
    LSP.${enums.name} = {
      ${enums.values.map((value: typeof enums.values[number]) => {
    switch (toTypeNotation(enums.type)) {
      case 'string': {
        return `${escapeLuaKeyword(value.name)} = ${JSON.stringify(value.value)},`;
      }
      case 'integer': {
        return `${escapeLuaKeyword(value.name)} = ${value.value},`;
      }
    }
    throw new Error(`Invalid enumeration type: ${enums.type.name}`);
  }).join('\n').trim()}
    }
  `;
}

/**
 * Generate struct definitions.
 */
function generateStruct(struct: MetaModel.Structure): string {
  const extend = (() => {
    const parents = [
      ...(struct.extends?.map(extend => {
        return extend.kind === 'reference' ? toPackageName(extend.name) : '';
      }) ?? []),
      ...(struct.mixins?.map(mixin => {
        return mixin.kind === 'reference' ? toPackageName(mixin.name) : '';
      }) ?? [])
    ].filter(Boolean);
    if (parents.length === 0) {
      return '';
    }
    return dedent` : ${parents.join(', ')}`;
  })();

  const mainStruct = dedent`
    ---@class ${toPackageName(struct.name)}${extend}
    ${struct.properties
      .map((prop: MetaModel.Property) => {
        const documentation = prop.documentation ? ` ${oneline(prop.documentation ?? '')}` : '';
        if (prop.type.kind === 'literal') {
          return `---@field public ${prop.name}${prop.optional ? '?' : ''} ${toPackageName(`${struct.name}.${prop.name}`)}${documentation}`;
        }
        return `---@field public ${prop.name}${prop.optional ? '?' : ''} ${toTypeNotation(prop.type)}${documentation}`;
      }).join('\n').trim()
    }

  `;
  const literalStruct = dedent`
    ${struct.properties
      .filter(prop => prop.type.kind === 'literal')
      .map((prop: MetaModel.Property) => {
        if (prop.type.kind !== 'literal') {
          return;
        }
        return generateStruct({
          name: `${struct.name}.${prop.name}`,
          ...prop.type.value,
        });
      }).join('\n\n').trim()
    }
  `;
  return dedent`
    ${mainStruct}
    ${literalStruct}
  `;
}

/**
 * Generate alias definitions.
 */
function generateAlias(alias: MetaModel.TypeAlias) {
  return dedent`
    ---@alias ${toPackageName(alias.name)} ${toTypeNotation(alias.type)}
  `;
}

/**
 * Get lua-language-server's notation.
 */
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
    // TODO: Tuple notation is not supported propery.
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
    // TODO: And notation is not supported propery.
    return '';
  } else if (type.kind === 'or') {
    return `(${type.items.map(toTypeNotation).join(' | ')})`;
  } else if (type.kind === 'map') {
    return `table<${toTypeNotation(type.key)}, ${toTypeNotation(type.value)}>`;
  }
  throw new Error(`Invalid type: ${JSON.stringify(type)}`);
}

/**
 * Get type name with namespace.
 */
function toPackageName(name: string) {
  return `___kit___.kit.LSP.${name}`;
}

/**
 * Escape Lua keywords.
 */
function escapeLuaKeyword(field: string) {
  return ({
    'function': "['function']",
    'local': "['local']",
  })[field] ?? field;
}

function oneline(s: string) {
  return s.replace(/(\r\n|\r|\n)/g, '<br>').trim();
}
