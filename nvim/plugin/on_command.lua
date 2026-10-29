--- Colorschemes.

local function setup_cappccin_latte()
  require("catppuccin").setup({
    flavor = "latte",
    no_italic = true,
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

local setups = {
  ["catppuccin-latte"] = setup_cappccin_latte,
  ["edge"] = setup_edge,
  ["gruvbox"] = setup_gruvbox,
  ["gruvbox-material"] = setup_gruvbox_material,
  ["kanagawa-lotus"] = setup_kangawa_lotus,
  ["rose-pine"] = setup_rose_pine,
  ["tokyonight-day"] = setup_tokyonight_day,
}

vim.api.nvim_create_user_command("LoadColortheme", function(args)
  local scheme = args.args

  setups[scheme]()
  vim.cmd("colorscheme " .. scheme)
end, {
  nargs = 1,
  complete = function()
    return {
      "catppuccin-latte",
      "edge",
      "gruvbox",
      "gruvbox-material",
      "kanagawa-lotus",
      "rose-pine",
      "tokyonight-day",
    }
  end,
  desc = "Load specified colorscheme",
})

--- Gitsigns

vim.api.nvim_create_user_command("LoadGitSigns", function()
  vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

  local opts = {
    on_attach = function()
      local map = vim.keymap.set

      map("n", "]h", function()
        require("gitsigns").nav_hunk("next")
      end, { desc = "Got to next hunk." })
      map("n", "[h", function()
        require("gitsigns").nav_hunk("prev")
      end, { desc = "Got to prev hunk." })

      map("n", "<Leader>hr", require("gitsigns").reset_hunk, { desc = "Reset hunk." })

      map(
        "n",
        "<Leader>hp",
        require("gitsigns").preview_hunk,
        { desc = "Preview current hunk at a floating window." }
      )
      map(
        "n",
        "<Leader>hi",
        require("gitsigns").preview_hunk_inline,
        { desc = "Preview current hunk inline." }
      )

      map(
        "n",
        "<Leader>hd",
        require("gitsigns").diffthis,
        { desc = "Perform vimdiff on current buffer against the index." }
      )
      map("n", "<Leader>hD", function()
        require("gitsigns").diffthis("~1")
      end, { desc = "Perform vimdiff on current buffer against the last commit." })

      map({ "o", "x" }, "ih", require("gitsigns").select_hunk, { desc = "Select current hunk." })
    end,
  }

  require("gitsigns").setup(opts)
end, { desc = "Load GitSigns" })
