import dedent from 'ts-dedent';
import * as MetaModel from '../../tmp/language-server-protocol/_specifications/lsp/3.18/metaModel/metaModel';

const state = {
  count: 0,
}

/**
 * Get lua-language-server's notation.
 */
export function toTypeNotation(type: MetaModel.Type, depends: string[] = []): string {
  depends = depends ?? [];

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
    return `${toTypeNotation(type.element, depends)}[]`;
  } else if (type.kind === 'tuple') {
    // TODO: Tuple notation is not supported propery.
    console.log('The `tuple` kind is limited support.')
    return `(${type.items.map(v => toTypeNotation(v, depends)).join(' | ')})[]`;
  } else if (type.kind === 'literal') {
    return `{ ${type.value.properties.map(prop => {
      return `${prop.name}${prop.optional ? '?' : ''}: ${toTypeNotation(prop.type, depends)}`;
    }).join(', ')} }`;
  } else if (type.kind === 'booleanLiteral') {
    return type.value ? 'true' : 'false';
  } else if (type.kind === 'stringLiteral') {
    return JSON.stringify(type.value);
  } else if (type.kind === 'integerLiteral') {
    return type.value.toString();
  } else if (type.kind === 'and') {
    console.log('The `and` kind is experimental support.')
    const name = 'IntersectionType' + ('0000' + ++state.count).slice(-2);
    depends.push(generateStruct({
      name: name,
      properties: [],
      extends: type.items
    }));
    return toPackageName(name);
  } else if (type.kind === 'or') {
    return `(${type.items.map(v => toTypeNotation(v, depends)).join(' | ')})`;
  } else if (type.kind === 'map') {
    return `table<${toTypeNotation(type.key, depends)}, ${toTypeNotation(type.value, depends)}>`;
  }
  throw new Error(`Invalid type: ${JSON.stringify(type)}`);
}

/**
 * Generate enum definitions.
 */
export function generateEnum(enums: MetaModel.Enumeration) {
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
export function generateStruct(struct: MetaModel.Structure): string {
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

  const mergedStruct = [] as string[];

  const mainStruct = dedent`
    ---@class ${toPackageName(struct.name)}${extend}
    ${struct.properties
      .map((prop: MetaModel.Property) => {
        const documentation = prop.documentation ? ` ${formatDocumentation(prop.documentation ?? '')}` : '';
        if (prop.type.kind === 'literal') {
          return `---@field public ${prop.name}${prop.optional ? '?' : ''} ${toPackageName(`${struct.name}.${prop.name}`)}${documentation}`;
        }
        return `---@field public ${prop.name}${prop.optional ? '?' : ''} ${toTypeNotation(prop.type, mergedStruct)}${documentation}`;
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
    ${mergedStruct.join('\n\n').trim()}
    ${mainStruct}
    ${literalStruct}
  `;
}

/**
 * Generate alias definitions.
 */
export function generateAlias(alias: MetaModel.TypeAlias) {
  return dedent`
    ---@alias ${toPackageName(alias.name)} ${toTypeNotation(alias.type)}
  `;
}

/**
 * Get type name with namespace.
 */
export function toPackageName(name: string) {
  return `___kit___.kit.LSP.${name}`;
}


/**
 * Format documentation.
 */
export function formatDocumentation(s: string) {
  return s.replace(/(\r\n|\r|\n)/g, '<br>').trim();
}

/**
 * Escape Lua keywords.
 */
function escapeLuaKeyword(field: string) {
  if (!field.match(/^[a-zA-Z_][a-zA-Z0-9_]*$/)) {
    return "['" + field + "']";
  }

  return ({
    'function': "['function']",
    'local': "['local']",
    'while': "['while']",
    'end': "['end']",
    'repeat': "['repeat']",
    'until': "['until']",
    'if': "['if']",
    'then': "['then']",
    'else': "['else']",
    'elseif': "['elseif']",
    'for': "['for']",
    'in': "['in']",
    'do': "['do']",
    'return': "['return']",
    'break': "['break']",
    'goto': "['goto']",
    'not': "['not']",
    'and': "['and']",
    'or': "['or']",
    'true': "['true']",
    'false': "['false']",
    'nil': "['nil']",
  })[field] ?? field;
}

export function method2type(method: string) {
  return method
    .replace(/^./g, s => {
      return s.toUpperCase();
    })
    .replace(/\/./g, s => {
      return s[1].toUpperCase();
    }) + 'Response';
}
