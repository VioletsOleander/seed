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
}

---@type LazyPluginSpec
local blink_cmp = {
  "saghen/blink.cmp",
  version = "*",
  event = { "InsertEnter" },
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = blink_opts,
}

---@type LazyPluginSpec
local nvim_surround = {
  "kylechui/nvim-surround",
  event = "VeryLazy",
  opts = {
    move_cursor = "sticky",
  },
}

---@type LazyPluginSpec
local nvim_autopair = {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,
  },
}

---@type LazyPluginSpec
local grug_far_nvim = {
  "MagicDuck/grug-far.nvim",
  cmd = { "GrugFar", "GrugFarWithin" },
}

---@type LazyPluginSpec
local gitsigns = {
  "lewis6991/gitsigns.nvim",
  cmd = "Gitsigns",
  opts = {
    on_attach = function()
      local gitsigns = require("gitsigns")
      local map = vim.keymap.set

      map("n", "]h", function()
        gitsigns.nav_hunk("next")
      end, { desc = "Got to next hunk." })
      map("n", "[h", function()
        gitsigns.nav_hunk("prev")
      end, { desc = "Got to prev hunk." })

      map("n", "<Leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk." })

      map(
        "n",
        "<Leader>hp",
        gitsigns.preview_hunk,
        { desc = "Preview current hunk at a floating window." }
      )
      map(
        "n",
        "<Leader>hi",
        gitsigns.preview_hunk_inline,
        { desc = "Preview current hunk inline." }
      )

      map(
        "n",
        "<Leader>hd",
        gitsigns.diffthis,
        { desc = "Perform vimdiff on current buffer against the index." }
      )
      map("n", "<Leader>hD", function()
        gitsigns.diffthis("~1")
      end, { desc = "Perform vimdiff on current buffer against the last commit." })

      map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select current hunk." })
    end,
  },
}

return { blink_cmp, nvim_surround, nvim_autopair, grug_far_nvim, gitsigns }
