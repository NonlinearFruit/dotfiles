local luasnip = require("luasnip")
local snippet = luasnip.snippet
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

return {
  snippet(
    "main",
    fmt(
      [[
        def --wrapped main [...rest] {{
          const pathToSelf = path self
          let nameOfSelf = $pathToSelf | path parse | get stem
          nu -c $'use ($pathToSelf); ($nameOfSelf) ($rest | str join (" "))'
        }}

    ]],
      {}
    )
  ),
  snippet(
    "shebang",
    fmt(
      [[
        #!/usr/bin/env nu

    ]],
      {}
    )
  ),
}
