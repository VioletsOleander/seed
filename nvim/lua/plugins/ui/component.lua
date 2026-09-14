---@module "lazy"

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
    signs = {
      add = { text = "┃" },
      change = { text = "┃" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    signs_staged = {
      add = { text = "┃" },
      change = { text = "┃" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
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
