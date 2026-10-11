---@module "lazy"

---@alias colortheme
---| '"gruvbox"'
---| '"gruvbox-material"'
---| '"edge"'
---| '"tokyonight-day"'
---| '"dayfox"'
---| '"rosepine"'
---| '"catppuccin-latte"'
---| '"kanagawa-lotus"'

---@type colortheme
local current_theme = "dayfox"

---@type LazyPluginSpec
local gruvbox_material = {
  "sainnhe/gruvbox-material",
  lazy = (current_theme ~= "gruvbox-material"),
  priority = 1000,
  config = function()
    vim.g.gruvbox_material_better_performance = 1
    vim.g.gruvbox_material_background = "medium"
    vim.g.gruvbox_material_disable_italic_comment = 1
    vim.cmd("colorscheme gruvbox-material")
  end,
}

---@type LazyPluginSpec
local gruvbox = {
  "ellisonleao/gruvbox.nvim",
  lazy = (current_theme ~= "gruvbox-material"),
  priority = 1000,
  config = function()
    require("gruvbox").setup({
      bold = false,
      italic = {
        strings = false,
        emphasis = false,
        comments = false,
        operators = false,
        folds = false,
      },
    })
    vim.cmd("colorscheme gruvbox")
  end,
}

---@type LazyPluginSpec
local edge = {
  "sainnhe/edge",
  lazy = (current_theme ~= "edge"),
  priority = 1000,
  config = function()
    vim.g.edge_better_performance = 1
    vim.g.edge_disable_italic_comment = 1
    vim.cmd("colorscheme edge")
  end,
}

---@type LazyPluginSpec
local tokyonight_day = {
  "folke/tokyonight.nvim",
  lazy = (current_theme ~= "tokyonight-day"),
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
      },
    })
    vim.cmd("colorscheme tokyonight-day")
  end,
}

---@type LazyPluginSpec
local dayfox = {
  "EdenEast/nightfox.nvim",
  lazy = (current_theme ~= "dayfox"),
  priority = 1000,
  config = function()
    require("nightfox").setup({
      groups = {
        -- The values defined under `all` will be applied to every style.
        all = {
          ["@markup.raw"] = { style = "NONE" },
        },
        -- dayfox = {
        --   -- Lighter than the default
        --   -- The constract between Normal:bg and ColorColumn:bg is now 1.08 (originally 1.33)
        --   -- ColorColumn = { bg = "#f0e8e5" },
        -- },
      },
    })
    vim.cmd("colorscheme dayfox")
  end,
}

---@type LazyPluginSpec
local rosepine = {
  "rose-pine/neovim",
  lazy = (current_theme ~= "rosepine"),
  priority = 1000,
  name = "rose-pine",
  config = function()
    require("rose-pine").setup({

      styles = {
        italic = false,
      },
    })
    vim.cmd("colorscheme rose-pine")
  end,
}

---@type LazyPluginSpec
local catppuccin_latte = {
  "catppuccin/nvim",
  lazy = (current_theme ~= "catppuccin_latte"),
  priority = 1000,
  name = "catppuccin",
  config = function()
    require("catppuccin").setup({
      flavor = "latte",
      no_italic = true,
    })
    vim.cmd("colorscheme catppuccin-latte")
  end,
}

local kanagawa_lotus = {
  "rebelot/kanagawa.nvim",
  lazy = (current_theme ~= "kanagawa-lotus"),
  priority = 1000,
  config = function()
    require("kanagawa").setup({
      commentStyle = { italic = false },
      keywordStyle = { italic = false },
    })
    vim.cmd("colorscheme kanagawa-lotus")
  end,
}

return {
  gruvbox,
  gruvbox_material,
  edge,
  tokyonight_day,
  dayfox,
  rosepine,
  catppuccin_latte,
  kanagawa_lotus,
}
