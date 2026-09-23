---@module "lazy"

local map = vim.keymap.set

---@type LazyPluginSpec
local mini_icons = {
  "nvim-mini/mini.icons",
  event = "VeryLazy",
  opts = {},
}

---@type LazyPluginSpec
local gitsigns = {
  "lewis6991/gitsigns.nvim",
  cmd = "Gitsigns",
  opts = {
    on_attach = function()
      local gitsigns = require("gitsigns")

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

---@type LazyPluginSpec
local markview = {
  "OXY2DEV/markview.nvim",
  cmd = "Markview",
  opts = {
    latex = {
      enable = false,
    },
    typst = {
      enable = false,
    },
  },
}

---@type LazyPluginSpec
local typst_preview = {
  "chomosuke/typst-preview.nvim",
  cmd = "TypstPreview",
}

---@type LazyPluginSpec
local lualine = {
  "nvim-lualine/lualine.nvim",
  lazy = true,
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

return { mini_icons, gitsigns, markview, typst_preview, lualine }
