local luasnip = require("luasnip")
local snippet = luasnip.snippet
local snippet_from_nodes = luasnip.sn
local t = luasnip.text_node
local i = luasnip.insert_node
local s = luasnip.snippet
local sn = luasnip.snippet_node
local f = luasnip.function_node
local c = luasnip.choice_node
local d = luasnip.dynamic_node
local r = luasnip.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")
local ts_utils = require("nvim-treesitter.ts_utils")

vim.treesitter.query.set(
  "c_sharp",
  "InlineDataArgs_Result",
  [[
    ((attribute_list
      (attribute
        name: (_) @id
        (attribute_argument_list) @it))
    (#eq? @id "InlineData"))
  ]]
)

---@param node TSNode?
local function get_parent_method_or_bust(node)
  if not node then
    return
  end
  if node:type() == "method_declaration" then
    return node
  end
  return get_parent_method_or_bust(node:parent())
end

---@param method_declaration TSNode
local function get_inline_data_attribute_argument_list_or_bust(method_declaration)
  local query = vim.treesitter.query.get("c_sharp", "InlineDataArgs_Result")
  if not query then
    return
  end
  local args
  for _, node in query:iter_captures(method_declaration, 0) do
    args = node
  end
  return args
end

---@param arg_list TSNode
local function get_args_as_nodes_or_bust(arg_list)
  local result = {}
  local count = arg_list:named_child_count()
  for index = 0, count - 1 do
    local node = arg_list:named_child(index)
    local param = vim.treesitter.get_node_text(node, 0)
    table.insert(result, i(index + 1, param))
    if index ~= count - 1 then
      table.insert(result, t({ ", " }))
    end
  end
  if #result == 0 then
    return
  end
  return result
end

local function create_snippet_nodes()
  local cursor_node = ts_utils.get_node_at_cursor()
  if not cursor_node then
    return
  end
  local parent = get_parent_method_or_bust(cursor_node)
  if not parent then
    return
  end
  local args = get_inline_data_attribute_argument_list_or_bust(parent)
  if not args then
    return
  end
  local params = get_args_as_nodes_or_bust(args)
  return params
end

local function inline_data_params_snippet()
  return snippet_from_nodes(nil, create_snippet_nodes() or { i(1, "") })
end

return {
  snippet(
    "fact",
    fmt(
      [[
                [Fact]
                public void test()
                {{
                    {}
                }}
            ]],
      { i(0) }
    )
  ),
  snippet(
    "theory",
    fmt(
      [[
                [Theory]
                [InlineData({})]
                public void theory({})
                {{
                    {}
                }}
            ]],
      { i(0), i(1), i(2) }
    )
  ),
  snippet(
    "inline",
    fmt(
      [[
                [InlineData({})]
            ]],
      { d(1, inline_data_params_snippet, {}) }
    )
  ),
}
