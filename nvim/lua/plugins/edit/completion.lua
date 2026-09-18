---@module "lazy"
---@module "blink.cmp"

---@type blink.cmp.Config
local blink_opts = {
  keymap = {
    preset = "none",
    ["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
    ["<C-e>"] = { "hide", "fallback" },
    ["<C-k>"] = { "select_prev", "fallback" },
    ["<C-j>"] = { "select_next", "fallback" },
    ["<C-f>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
    ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
  },
  signature = { enabled = false, window = { show_documentation = true } },
  completion = {
    list = {
      selection = {
        auto_insert = false,
      },
    },
    accept = {
      dot_repeat = false,
      auto_brackets = {
        enabled = false,
      },
    },
    documentation = { auto_show = false },
    menu = {
      draw = {
        columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } },
        components = {
          kind_icon = {
            text = function(ctx)
              local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
              return kind_icon
            end,
          },
        },
      },
    },
  },
  sources = { default = { "lsp", "snippets", "buffer" } },
  fuzzy = { implementation = "rust" },
  cmdline = {
    enabled = false,
    keymap = {
      preset = "none",
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
    },
    completion = {
      menu = { auto_show = true },
      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        },
      },
    },
  },
  snippets = {
    preset = "luasnip",
  },
}

---@type LazyPluginSpec
local blink_cmp = {
  "saghen/blink.cmp",
  version = "*",
  event = { "InsertEnter" },
  dependencies = { "L3MON4D3/LuaSnip", "rafamadriz/friendly-snippets" },
  opts = blink_opts,
}

---@type LazyPluginSpec
local luasnip = {
  "L3MON4D3/LuaSnip",
  lazy = true,
  submodules = false,
  config = function()
    require("luasnip.config").setup({ enable_autosnippets = true })
  end,
}

---@type LazyPluginSpec
local luasnip_latex_snippets = {
  "iurimateus/luasnip-latex-snippets.nvim",
  lazy = true,
  requires = { "L3MON4D3/LuaSnip" },
  opts = {
    use_treesitter = true,
    allow_on_markdown = true,
  },
}

return { blink_cmp, luasnip, luasnip_latex_snippets }
