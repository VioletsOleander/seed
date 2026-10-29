vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/folke/snacks.nvim",
  -- Themes.
  "https://github.com/EdenEast/nightfox.nvim",
  "https://github.com/ellisonleao/gruvbox.nvim",
  "https://github.com/folke/tokyonight.nvim",
  "https://github.com/sainnhe/edge",
  "https://github.com/sainnhe/gruvbox-material",
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
})

local safely = require("util").safely

--- Nightfox.

safely(function()
  local opts = {
    groups = {
      all = { ["@markup.raw"] = { style = "NONE" } },
      dayfox = { MatchParen = { bg = "#E7D2BE" } },
    },
  }

  require("nightfox").setup(opts)
  vim.cmd("colorscheme dayfox")
end)

--- Mini.icons.

safely(function()
  require("mini.icons").setup()
end)

--- Snacks.

safely(function()
  vim.g.snacks_animate = false
  local map = vim.keymap.set

  -- Snacks.picker.smart will aggregate result from files, recent, buffers.
  map("n", "<Leader><Space>", function()
    Snacks.picker.smart()
  end, { desc = "Find files and buffers." })

  map("n", "<Leader>:", function()
    Snacks.picker.command_history()
  end, { desc = "Show command history." })

  -- map("n", "<Leader>e", function()
  --   Snacks.explorer()
  -- end, { desc = "Toggle file explorer based on current working directory." })

  -- Buffer (b).
  map("n", "<Leader>l", function()
    Snacks.picker.buffers()
  end, { desc = "Find buffers." })

  -- File (f).
  map("n", "<Leader>j", function()
    Snacks.picker.files()
  end, { desc = "Find files." })
  map("n", "<Leader>k", function()
    Snacks.picker.recent()
  end, { desc = "Find recent files." })
  map("n", "<Leader>fc", function()
    Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
  end, { desc = "Find config files." })

  -- Grep (g).
  map("n", "<Leader>/", function()
    Snacks.picker.grep()
  end, { desc = "Grep search." })
  map("n", "<Leader>gb", function()
    Snacks.picker.grep_buffers()
  end, { desc = "Grep search opened buffers." })
  map({ "n", "x" }, "<Leader>gw", function()
    Snacks.picker.grep_word()
  end, { desc = "Grep search visual selection or word." })
  map("n", "<Leader>gh", function()
    local help_dirs = vim.api.nvim_get_runtime_file("doc/*.txt", true)
    Snacks.picker.grep({ dirs = help_dirs, live = true })
  end, { desc = "Grep search help." })

  -- Git (g).
  map("n", "<Leader>gl", function()
    Snacks.picker.git_log()
  end, { desc = "Show git log." })
  map("n", "<Leader>gs", function()
    Snacks.picker.git_status()
  end, { desc = "Show git status." })
  map("n", "<Leader>gd", function()
    Snacks.picker.git_diff()
  end, { desc = "Show git diff." })

  -- Search/Show (s).
  map("n", "<Leader>sl", function()
    Snacks.picker.spelling()
  end, { desc = "Show spelling suggestions." })
  map("n", "<Leader>sn", function()
    Snacks.picker.notifications()
  end, { desc = "Show notification history." })
  map("n", '<Leader>s"', function()
    Snacks.picker.registers()
  end, { desc = "Search registers." })
  map("n", "<Leader>s/", function()
    Snacks.picker.search_history()
  end, { desc = "Search 'search' history." })
  map("n", "<Leader>sa", function()
    Snacks.picker.autocmds()
  end, { desc = "Search autocmds." })
  map("n", "<Leader>sb", function()
    Snacks.picker.lines()
  end, { desc = "Search buffer lines." })
  map("n", "<Leader>sc", function()
    Snacks.picker.commands()
  end, { desc = "Search commands." })
  map("n", "<Leader>sD", function()
    Snacks.picker.diagnostics()
  end, { desc = "Search diagnostics." })
  map("n", "<Leader>sd", function()
    Snacks.picker.diagnostics_buffer()
  end, { desc = "Search buffer diagnostics." })
  map("n", "<Leader>sh", function()
    Snacks.picker.help()
  end, { desc = "Search help pages." })
  map("n", "<Leader>sH", function()
    Snacks.picker.highlights()
  end, { desc = "Search highlights." })
  map("n", "<Leader>sj", function()
    Snacks.picker.jumps()
  end, { desc = "Search jumps." })
  map("n", "<Leader>sk", function()
    Snacks.picker.keymaps()
  end, { desc = "Search keymaps." })
  map("n", "<Leader>sm", function()
    Snacks.picker.marks()
  end, { desc = "Search marks." })
  map("n", "<Leader>sM", function()
    Snacks.picker.man()
  end, { desc = "Search man pages." })
  map("n", "<Leader>sp", function()
    Snacks.picker.projects()
  end, { desc = "Search projects." })
  map("n", "<Leader>sq", function()
    Snacks.picker.qflist()
  end, { desc = "Search quickfix list." })
  map("n", "<Leader>sr", function()
    Snacks.picker.resume()
  end, { desc = "Resume last search." })
  map("n", "<Leader>su", function()
    Snacks.picker.undo()
  end, { desc = "Search undo history." })

  -- LSP (s).
  map("n", "<Leader>ss", function()
    Snacks.picker.lsp_symbols()
  end, { desc = "Search lsp symbols." })
  map("n", "<Leader>sS", function()
    Snacks.picker.lsp_workspace_symbols()
  end, { desc = "Search lsp workspace symbols." })

  local opts = {
    bufdelete = { enabled = true },
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    indent = { enabled = true },
    notifier = { enabled = true, timeout = 3000 },
    picker = {
      enabled = true,
      -- Make sure that picker's open the target in current window, instead of finding a window with file buffer.
      -- Otherwise, if current window is terminal, picker will not open the target in current window.
      main = { current = true },
      actions = {
        ["list_scroll_down_quarter"] = function(picker)
          picker.list:scroll(math.ceil(picker.list.state.scroll / 2))
        end,
        ["list_scroll_up_quarter"] = function(picker)
          picker.list:scroll(-math.ceil(picker.list.state.scroll / 2))
        end,
      },
      win = {
        -- Hint: set to false to prevent snack's default keymap.
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "i", "n" } },
            ["<C-q>"] = { "close", mode = { "i", "n" } },
            ["<M-q>"] = { "qflist", mode = { "i", "n" } },
            ["<C-f>"] = { "focus_list", mode = { "i", "n" } },
          },
        },
        list = {
          keys = {
            ["<Esc>"] = { "close", mode = "n" },
            ["<C-q>"] = { "close", mode = "n" },
            ["<M-q>"] = { "qflist", mode = "n" },
            ["<C-f>"] = { "focus_input", mode = "n" },
            ["<C-e>"] = { "list_scroll_down_quarter", mode = "n" },
            ["<C-y>"] = { "list_scroll_up_quarter", mode = "n" },
            ["<C-n>"] = false,
            ["/"] = false,
          },
        },
      },
      sources = {
        files = {
          win = {
            input = {
              keys = {
                ["<C-h>"] = { "toggle_hidden", mode = "i" },
                ["<C-i>"] = { "toggle_ignored", mode = "i" },
              },
            },
            list = {
              keys = {
                ["H"] = { "toggle_hidden", mode = "n" },
                ["I"] = { "toggle_ignored", mode = "n" },
              },
            },
          },
        },
      },
    },
  }

  require("snacks").setup(opts)
end)

--- Treesitter

safely(function()
  local treesitter_langauges = {
    "bash",
    "css",
    "gitcommit",
    "gitignore",
    "html",
    "javascript",
    "json",
    "json5",
    "lua",
    "markdown",
    "nu",
    "python",
    "rust",
    "svelte",
    "latex",
    "toml",
    "typescript",
    "typst",
    "vim",
    "yaml",
  }

  require("nvim-treesitter").install(treesitter_langauges)

  vim.api.nvim_create_autocmd("FileType", {
    pattern = treesitter_langauges,
    callback = function(ev)
      vim.treesitter.start(ev.buf)
    end,
  })

  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      local name, kind = ev.data.spec.name, ev.data.kind

      if name == "nvim-treesitter" and kind == "update" then
        if not ev.data.active then
          vim.cmd.packadd("nvim-treesitter")
        end

        vim.cmd("TSUpdate")
      end
    end,
  })
end)
