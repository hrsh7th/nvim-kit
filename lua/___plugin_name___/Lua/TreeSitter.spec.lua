---@diagnostic disable: need-check-nil, param-type-mismatch

local helper = require('kit.helper')
local TreeSitter = require('___plugin_name___.Lua.TreeSitter')

local pairs = {
  if_statement = {
    ['if'] = true,
    elseif_statement = {
      ['elseif'] = true,
    },
    else_statement = {
      ['else'] = true,
    },
    ['end'] = true,
  },
  for_statement = {
    ['for'] = true,
    ['end'] = true,
  },
  table_constructor = {
    ['{'] = true,
    ['}'] = true,
  },
  while_statement = {
    ['while'] = true,
    ['end'] = true,
  },
  function_definition = {
    ['function'] = true,
    ['end'] = true,
  },
  function_declaration = {
    ['function'] = true,
    ['end'] = true,
  },
  parameters = {
    ['('] = true,
    [')'] = true,
  },
  arguments = {
    ['('] = true,
    [')'] = true,
  },
  parenthesized_expression = {
    ['('] = true,
    [')'] = true,
  },
}

describe('kit.Lua.TreeSitter', function()

  before_each(function()
    vim.cmd([[
      enew!
      syntax off
      set filetype=lua
      call setline(1, [
      \   'function A()',
      \   '  return 1',
      \   'end',
      \   'if "then" then',
      \   '  print(a())',
      \   'elseif "else if" then',
      \   '  print(a())',
      \   'elseif "else if" then',
      \   '  if "then" then',
      \   '    return 1',
      \   '  end',
      \   'else',
      \   '  print(a())',
      \   'end',
      \   '',
      \ ])
    ]])
  end)

  it('get_node_at', function()
    helper.ensure_treesitter_parser('lua')
    assert.are.equals(TreeSitter.get_node_at(0, 9):type(), 'identifier')
    assert.are.equals(TreeSitter.get_node_at(1, 0):type(), 'return')
    assert.are.equals(TreeSitter.get_node_at(1, 2):type(), 'return')
    assert.are.equals(TreeSitter.get_node_at(1, 8):type(), 'number')
    assert.are.equals(TreeSitter.get_node_at(1, 11):type(), 'end')
  end)

  it('search_next', function()
    helper.ensure_treesitter_parser('lua')
    local node = TreeSitter.get_node_at(0, 0)
    for _, position in ipairs({
      { 0, 10 },
      { 4, 7 },
      { 4, 9 },
      { 6, 7 },
      { 6, 9 },
      { 12, 7 },
      { 12, 9 },
    }) do
      node = TreeSitter.search_next(node, function(node_)
        return node_:type() == '('
      end)
      local node_start = { node:start() }
      assert.are.same({ node_start[1], node_start[2] }, position)
    end
  end)

  it('extract', function()
    helper.ensure_treesitter_parser('lua')
    local if_statement = TreeSitter.search_next(TreeSitter.get_node_at(0, 0), function(node)
      return node:type() == 'if_statement'
    end)
    local nodes = TreeSitter.extract(if_statement, pairs)
    assert.are.same(nodes[1]:type(), 'if')
    assert.are.same(nodes[2]:type(), 'elseif')
    assert.are.same(nodes[3]:type(), 'elseif')
    assert.are.same(nodes[4]:type(), 'else')
    assert.are.same(nodes[5]:type(), 'end')
  end)

  it('matches', function()
    helper.ensure_treesitter_parser('lua')
    local if_statement = TreeSitter.search_next(TreeSitter.get_node_at(0, 0), function(node)
      return node:type() == 'if_statement'
    end)
    local nodes = TreeSitter.extract(if_statement, pairs)
    assert.are_not.is_nil(TreeSitter.matches(nodes[1], pairs))
    assert.are_not.is_nil(TreeSitter.matches(nodes[2], pairs))
    assert.are_not.is_nil(TreeSitter.matches(nodes[3], pairs))
    assert.are_not.is_nil(TreeSitter.matches(nodes[4], pairs))
    assert.are_not.is_nil(TreeSitter.matches(nodes[5], pairs))
    assert.is_nil(TreeSitter.matches(TreeSitter.get_node_at(1, 2), pairs))
  end)

  it('search_next_pair', function()
    helper.ensure_treesitter_parser('lua')
    local node = TreeSitter.search_next(TreeSitter.get_node_at(0, 0), function(node)
      return node:type() == 'if_statement'
    end)
    for _, position in ipairs({
      { 5, 0 },
      { 7, 0 },
      { 11, 0 },
      { 13, 0 },
      { 3, 0 },
    }) do
      node = TreeSitter.search_next_pair(node, pairs)
      local node_start = { node:start() }
      assert.are.same({ node_start[1], node_start[2] }, position)
    end
  end)

end)
