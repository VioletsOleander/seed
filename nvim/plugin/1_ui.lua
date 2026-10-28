--- Add packages.

vim.pack.add({
  "https://github.com/nvim-mini/mini.icons",
  "https://github.com/sainnhe/gruvbox-material",
  "https://github.com/ellisonleao/gruvbox.nvim",
  "https://github.com/sainnhe/edge",
  "https://github.com/folke/tokyonight.nvim",
  "https://github.com/EdenEast/nightfox.nvim",
  { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
})

--- Define colorthemes to load.

---@alias theme
---| '"catppuccin-latte"'
---| '"dayfox"'
---| '"edge"'
---| '"gruvbox"'
---| '"gruvbox-material"'
---| '"kanagawa-lotus"'
---| '"rosepine"'
---| '"tokyonight-day"'

---@type theme
local theme = "dayfox"

local function setup_cappccin_latte()
  require("catppuccin").setup({
    flavor = "latte",
    no_italic = true,
  })
end

local function setup_dayfox()
  require("nightfox").setup({
    groups = {
      -- The values defined under `all` will be applied to every style.
      all = {
        ["@markup.raw"] = { style = "NONE" },
      },
      dayfox = {
        -- Lighter than the default
        -- The constract between Normal:bg and ColorColumn:bg is now 1.08 (originally 1.33)
        -- ColorColumn = { bg = "#f0e8e5" },
        MatchParen = { bg = "#E7D2BE" },
      },
    },
  })
end

local function setup_edge()
  vim.g.edge_better_performance = 1
  vim.g.edge_disable_italic_comment = 1
end

local function setup_gruvbox()
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
end

local function setup_gruvbox_material()
  vim.g.gruvbox_material_better_performance = 1
  vim.g.gruvbox_material_background = "medium"
  vim.g.gruvbox_material_disable_italic_comment = 1
end

local function setup_kangawa_lotus()
  require("kanagawa").setup({
    commentStyle = { italic = false },
    keywordStyle = { italic = false },
  })
end

local function setup_rose_pine()
  require("rose-pine").setup({
    styles = { italic = false },
  })
end

local function setup_tokyonight_day()
  require("tokyonight").setup({
    styles = {
      comments = { italic = false },
      keywords = { italic = false },
    },
  })
end

---@type table<theme, function>
local setups = {
  ["catppuccin-latte"] = setup_cappccin_latte,
  ["dayfox"] = setup_dayfox,
  ["edge"] = setup_edge,
  ["gruvbox"] = setup_gruvbox,
  ["gruvbox-material"] = setup_gruvbox_material,
  ["kanagawa-lotus"] = setup_kangawa_lotus,
  ["rose-pine"] = setup_rose_pine,
  ["tokyonight-day"] = setup_tokyonight_day,
}

local com = vim.api.nvim_create_user_command

com(
  "LoadColortheme",
  ---@param args table
  function(args)
    local theme = args.args
    setups[theme]()

    vim.cmd("colorscheme " .. theme)
  end,
  {
    nargs = 1,
    complete = function()
      return {
        "catppuccin-latte",
        "dayfox",
        "edge",
        "gruvbox",
        "gruvbox-material",
        "kanagawa-lotus",
        "rose-pine",
        "tokyonight-day",
      }
    end,
    desc = "Load specified colortheme",
  }
)

--- Setup mini icons.

require("mini.icons").setup()

--- Setup and load the specified colortheme.

setups[theme]()
vim.cmd("colorscheme " .. theme)
