---@module "lazy"
---@module "snacks"

---@type snacks.Config
local snacks_opts = {
  bufdelete = { enabled = true },
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  indent = { enabled = true },
  notifier = { enabled = true, timeout = 3000 },
  explorer = { enabled = true },
  picker = {
    enabled = true,
    -- Make sure that picker's open the target in current window, instead of finding a window with file buffer.
    -- Otherwise, if current window is terminal, picker will not open the target in current window.
    main = { current = true },
    -- Frequency bonus.
    matcher = { frecency = true },
    win = {
      input = {
        keys = {
          ["<Esc>"] = { "close", mode = { "i", "n" } },
          ["<C-q>"] = { "close", mode = { "i", "n" } },
          ["/"] = { "toggle_focus", mode = { "i", "n" } },
        },
      },
      list = {
        keys = {
          ["<Esc>"] = { "close", mode = "n" },
          ["<C-q>"] = { "close", mode = "n" },
          -- Set to false to prevent snack's default keymap.
          ["/"] = false,
          ["<C-n>"] = false,
        },
      },
    },
    sources = {
      explorer = {
        hidden = true,
        follow_file = false,
        matcher = { fuzzy = true },
        -- Show preview in the buffer window.
        layout = { preview = "main", hidden = { "preview" } },
        win = {
          input = {
            keys = {
              -- Do not let Esc close explorer.
              ["<Esc>"] = false,
              ["<C-h>"] = { "toggle_hidden", mode = "i" },
              ["<C-i>"] = { "toggle_ignored", mode = "i" },
            },
          },
          list = {
            keys = {
              ["<Esc>"] = false,
              ["H"] = { "toggle_hidden", mode = "n" },
              ["I"] = { "toggle_ignored", mode = "n" },
            },
          },
        },
      },
      files = {
        hidden = true,
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

local function set_snacks_keymaps()
  local map = vim.keymap.set

  map("n", "<Leader>:", function()
    require("snacks").picker.command_history()
  end, { desc = "Show command history." })

  map("n", "<Leader>e", function()
    require("snacks").explorer()
  end, { desc = "Toggle file explorer based on current working directory." })

  -- Buffer (b).
  map("n", "<Leader>l", function()
    require("snacks").picker.buffers()
  end, { desc = "Find buffers." })

  -- File (f).
  -- require("snacks").picker.smart will aggregate result from these three pickers.
  -- We aims to be precise, therefore do not map require("snacks").picker.smart, but use the specific one.
  map("n", "<Leader>j", function()
    require("snacks").picker.files()
  end, { desc = "Find files." })
  map("n", "<Leader>k", function()
    require("snacks").picker.recent()
  end, { desc = "Find recent files." })
  map("n", "<Leader>fc", function()
    require("snacks").picker.files({ cwd = vim.fn.stdpath("config") })
  end, { desc = "Find config files." })

  -- Grep (g).
  map("n", "<Leader>/", function()
    require("snacks").picker.grep()
  end, { desc = "Grep search." })
  map("n", "<Leader>gb", function()
    require("snacks").picker.grep_buffers()
  end, { desc = "Grep search opened buffers." })
  map({ "n", "x" }, "<Leader>gw", function()
    require("snacks").picker.grep_word()
  end, { desc = "Grep search visual selection or word." })
  map("n", "<Leader>gh", function()
    local help_dirs = vim.api.nvim_get_runtime_file("doc/*.txt", true)
    require("snacks").picker.grep({ dirs = help_dirs, live = true })
  end, { desc = "Grep search help." })

  -- Git (g).
  map("n", "<Leader>gl", function()
    require("snacks").picker.git_log()
  end, { desc = "Show git log." })
  map("n", "<Leader>gs", function()
    require("snacks").picker.git_status()
  end, { desc = "Show git status." })
  map("n", "<Leader>gd", function()
    require("snacks").picker.git_diff()
  end, { desc = "Show git diff." })

  -- Search/Show (s).
  map("n", "<Leader>sl", function()
    require("snacks").picker.spelling()
  end, { desc = "Show spelling suggestions." })
  map("n", "<Leader>sn", function()
    require("snacks").picker.notifications()
  end, { desc = "Show notification history." })
  map("n", '<Leader>s"', function()
    require("snacks").picker.registers()
  end, { desc = "Search registers." })
  map("n", "<Leader>s/", function()
    require("snacks").picker.search_history()
  end, { desc = "Search 'search' history." })
  map("n", "<Leader>sa", function()
    require("snacks").picker.autocmds()
  end, { desc = "Search autocmds." })
  map("n", "<Leader>sb", function()
    require("snacks").picker.lines()
  end, { desc = "Search buffer lines." })
  map("n", "<Leader>sc", function()
    require("snacks").picker.commands()
  end, { desc = "Search commands." })
  map("n", "<Leader>sD", function()
    require("snacks").picker.diagnostics()
  end, { desc = "Search diagnostics." })
  map("n", "<Leader>sd", function()
    require("snacks").picker.diagnostics_buffer()
  end, { desc = "Search buffer diagnostics." })
  map("n", "<Leader>sh", function()
    require("snacks").picker.help()
  end, { desc = "Search help pages." })
  map("n", "<Leader>sH", function()
    require("snacks").picker.highlights()
  end, { desc = "Search highlights." })
  map("n", "<Leader>sj", function()
    require("snacks").picker.jumps()
  end, { desc = "Search jumps." })
  map("n", "<Leader>sk", function()
    require("snacks").picker.keymaps()
  end, { desc = "Search keymaps." })
  map("n", "<Leader>sm", function()
    require("snacks").picker.marks()
  end, { desc = "Search marks." })
  map("n", "<Leader>sM", function()
    require("snacks").picker.man()
  end, { desc = "Search man pages." })
  map("n", "<Leader>sp", function()
    require("snacks").picker.projects()
  end, { desc = "Search projects." })
  map("n", "<Leader>sq", function()
    require("snacks").picker.qflist()
  end, { desc = "Search quickfix list." })
  map("n", "<Leader>sr", function()
    require("snacks").picker.resume()
  end, { desc = "Resume last search." })
  map("n", "<Leader>su", function()
    require("snacks").picker.undo()
  end, { desc = "Search undo history." })

  -- LSP (s).
  map("n", "<Leader>ss", function()
    require("snacks").picker.lsp_symbols()
  end, { desc = "Search lsp symbols." })
  map("n", "<Leader>sS", function()
    require("snacks").picker.lsp_workspace_symbols()
  end, { desc = "Search lsp workspace symbols." })
end

---@type LazyPluginSpec
local snacks = {
  "folke/snacks.nvim",
  priority = 1000,
  config = function()
    vim.g.snacks_animate = false
    set_snacks_keymaps()
    require("snacks").setup(snacks_opts)
  end,
}

return { snacks }
