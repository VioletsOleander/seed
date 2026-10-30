local function setup_cappccin()
  require("catppuccin").setup({
    flavor = "latte",
    no_italic = true,
  })
  vim.cmd("colorscheme catppuccin-latte")
end

local function setup_edge()
  vim.g.edge_better_performance = 1
  vim.g.edge_disable_italic_comment = 1
  vim.cmd("colorscheme edge")
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
  vim.cmd("colorscheme gruvbox")
end

local function setup_gruvbox_material()
  vim.g.gruvbox_material_better_performance = 1
  vim.g.gruvbox_material_background = "medium"
  vim.g.gruvbox_material_disable_italic_comment = 1
  vim.cmd("colorscheme gruvbox-material")
end

local function setup_kangawa()
  require("kanagawa").setup({
    commentStyle = { italic = false },
    keywordStyle = { italic = false },
  })
  vim.cmd("colorscheme kanagawa-lotus")
end

local function setup_rose_pine()
  require("rose-pine").setup({ styles = { italic = false } })
  vim.cmd("colorscheme rose-pine")
end

local function setup_tokyonight()
  require("tokyonight").setup({
    styles = {
      comments = { italic = false },
      keywords = { italic = false },
    },
  })
  vim.cmd("colorscheme tokyonight-day")
end

local function setup_gitsigns()
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
end

local function setup_minigit()
  require("mini.git").setup()
end

local setups = {
  ["catppuccin"] = setup_cappccin,
  ["edge"] = setup_edge,
  ["gruvbox"] = setup_gruvbox,
  ["gruvbox-material"] = setup_gruvbox_material,
  ["kanagawa-lotus"] = setup_kangawa,
  ["rose-pine"] = setup_rose_pine,
  ["tokyonight-day"] = setup_tokyonight,
  ["gitsigns"] = setup_gitsigns,
  ["mini.git"] = setup_minigit,
}

vim.api.nvim_create_user_command("Load", function(args)
  local plug = args.args
  local setup = setups[plug]

  setups[plug] = nil
  setup()
end, {
  nargs = 1,
  complete = function()
    local keys = vim.tbl_keys(setups)
    table.sort(keys)

    return keys
  end,
  desc = "Load specified plugin",
})
