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
  map("n", "<Leader><Space>", require("snacks").picker.smart, { desc = "Find files and buffers." })
  map(
    "n",
    "<Leader>:",
    require("snacks").picker.command_history,
    { desc = "Show command history." }
  )

  -- Buffer (b).
  map("n", "<Leader>l", require("snacks").picker.buffers, { desc = "Find buffers." })

  -- File (f).
  map("n", "<Leader>j", require("snacks").picker.files, { desc = "Find files." })
  map("n", "<Leader>k", require("snacks").picker.recent, { desc = "Find recent files." })
  map("n", "<Leader>fc", function()
    require("snacks").picker.files({ cwd = vim.fn.stdpath("config") })
  end, { desc = "Find config files." })

  -- Grep (g).
  map("n", "<Leader>/", require("snacks").picker.grep, { desc = "Grep search." })
  map(
    "n",
    "<Leader>gb",
    require("snacks").picker.grep_buffers,
    { desc = "Grep search opened buffers." }
  )
  map(
    { "n", "x" },
    "<Leader>gw",
    require("snacks").picker.grep_word,
    { desc = "Grep search visual selection or word." }
  )
  map("n", "<Leader>gh", function()
    local help_dirs = vim.api.nvim_get_runtime_file("doc/*.txt", true)
    require("snacks").picker.grep({ dirs = help_dirs, live = true })
  end, { desc = "Grep search help." })

  -- Git (g).
  map("n", "<Leader>gl", require("snacks").picker.git_log, { desc = "Show git log." })
  map("n", "<Leader>gs", require("snacks").picker.git_status, { desc = "Show git status." })
  map("n", "<Leader>gd", require("snacks").picker.git_diff, { desc = "Show git diff." })

  -- Search/Show (s).
  map("n", "<Leader>sl", require("snacks").picker.spelling, { desc = "Show spelling suggestions." })
  map(
    "n",
    "<Leader>sn",
    require("snacks").picker.notifications,
    { desc = "Show notification history." }
  )
  map("n", '<Leader>s"', require("snacks").picker.registers, { desc = "Search registers." })
  map(
    "n",
    "<Leader>s/",
    require("snacks").picker.search_history,
    { desc = "Search 'search' history." }
  )
  map("n", "<Leader>sa", require("snacks").picker.autocmds, { desc = "Search autocmds." })
  map("n", "<Leader>sb", require("snacks").picker.lines, { desc = "Search buffer lines." })
  map("n", "<Leader>sc", require("snacks").picker.commands, { desc = "Search commands." })
  map("n", "<Leader>sD", require("snacks").picker.diagnostics, { desc = "Search diagnostics." })
  map(
    "n",
    "<Leader>sd",
    require("snacks").picker.diagnostics_buffer,
    { desc = "Search buffer diagnostics." }
  )
  map("n", "<Leader>sh", require("snacks").picker.help, { desc = "Search help pages." })
  map("n", "<Leader>sH", require("snacks").picker.highlights, { desc = "Search highlights." })
  map("n", "<Leader>sj", require("snacks").picker.jumps, { desc = "Search jumps." })
  map("n", "<Leader>sk", require("snacks").picker.keymaps, { desc = "Search keymaps." })
  map("n", "<Leader>sm", require("snacks").picker.marks, { desc = "Search marks." })
  map("n", "<Leader>sM", require("snacks").picker.man, { desc = "Search man pages." })
  map("n", "<Leader>sp", require("snacks").picker.projects, { desc = "Search projects." })
  map("n", "<Leader>sq", require("snacks").picker.qflist, { desc = "Search quickfix list." })
  map("n", "<Leader>sr", require("snacks").picker.resume, { desc = "Resume last search." })

  -- LSP (s).
  map("n", "<Leader>ss", require("snacks").picker.lsp_symbols, { desc = "Search lsp symbols." })
  map(
    "n",
    "<Leader>sS",
    require("snacks").picker.lsp_workspace_symbols,
    { desc = "Search lsp workspace symbols." }
  )

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
            ["/"] = { "focus_list", mode = { "i", "n" } },
          },
        },
        list = {
          keys = {
            ["<Esc>"] = { "close", mode = "n" },
            ["<C-q>"] = { "close", mode = "n" },
            ["<M-q>"] = { "qflist", mode = "n" },
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
    "fish",
    "gitcommit",
    "gitignore",
    "html",
    "javascript",
    "json",
    "json5",
    "latex",
    "lua",
    "markdown",
    "nu",
    "python",
    "rust",
    "svelte",
    "toml",
    "typescript",
    "typst",
    "vim",
    "yaml",
  }

  require("nvim-treesitter").install(treesitter_langauges)

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("user", { clear = false }),
    pattern = treesitter_langauges,
    callback = function(ev)
      vim.treesitter.start(ev.buf)
    end,
  })

  vim.api.nvim_create_autocmd("PackChanged", {
    group = vim.api.nvim_create_augroup("user", { clear = false }),
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
