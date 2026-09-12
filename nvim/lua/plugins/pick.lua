---@module "lazy"
---@module "neo-tree"
---@module "snacks"

local map = vim.keymap.set

---@type snacks.Config
local snacks_opts = {
  -- File load
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  -- UI
  indent = { enabled = true },
  notifier = { enabled = true, timeout = 3000 },
  bufdelete = { enabled = true },
  -- Picker
  picker = {
    enabled = true,
    actions = {
      ---@diagnostic disable-next-line: assign-type-mismatch
      list_down_5 = function(picker)
        picker.list:move(5)
      end,
      ---@diagnostic disable-next-line: assign-type-mismatch
      list_up_5 = function(picker)
        picker.list:move(-5)
      end,
      ---@diagnostic disable-next-line: assign-type-mismatch
      emit_esc = function()
        local esc = vim.keycode("<Esc>")
        vim.api.nvim_feedkeys(esc, "n", false)
      end,
      ---@diagnostic disable-next-line: assign-type-mismatch
      emit_slash = function()
        vim.api.nvim_feedkeys("/", "n", false)
      end,
      ---@diagnostic disable-next-line: assign-type-mismatch
      clear_hl = function()
        vim.cmd("nohlsearch")
      end,
    },
    -- This makes sure that picker's jump in terminal window is correct.
    -- Othewise snacks will search for a file buffer to open the picked one, instead of open the
    -- picked one in current pane
    main = { current = true },
    win = {
      input = {
        keys = {
          ["/"] = { "toggle_focus", mode = { "i", "n" } },
          ["<Esc>"] = { "close", mode = { "i", "n" } },
          ["<C-q>"] = { "close", mode = { "i", "n" } },
          ["<C-j>"] = { "list_down", mode = { "i", "n" } },
          ["<C-k>"] = { "list_up", mode = { "i", "n" } },
          ["jk"] = { "confirm", mode = { "i", "n" } },
          ["<C-c>"] = { "clear_hl", mode = { "i", "n" } },
        },
      },
      list = {
        keys = {
          ["/"] = { "emit_slash", mode = "n" },
          ["<Esc>"] = { "close", mode = "n" },
          ["<C-q>"] = { "close", mode = "n" },
          ["<C-j>"] = { "list_down_5", mode = "n" },
          ["<C-k>"] = { "list_up_5", mode = "n" },
          ["jk"] = { "confirm", mode = "n" },
          ["<C-c>"] = { "clear_hl", mode = "n" },
        },
      },
    },
    sources = {
      files = {
        hidden = true,
        ignored = true,
      },
    },
  },
}

local function set_snacks_keymap()
  map("n", "<Leader>:", function()
    Snacks.picker.command_history()
  end, { desc = "Show command history" })

  -- Buffer (b)
  map("n", "<Leader>l", function()
    Snacks.picker.buffers()
  end, { desc = "Find buffers" })

  -- File (f)
  map("n", "<Leader><Space>", function()
    Snacks.picker.smart()
  end, { desc = "Smart find files" })
  map("n", "<Leader>j", function()
    Snacks.picker.files()
  end, { desc = "Find files" })
  map("n", "<Leader>k", function()
    Snacks.picker.recent()
  end, { desc = "Find recent files" })
  map("n", "<Leader>fc", function()
    Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
  end, { desc = "Find config files" })

  -- Grep (g)
  map("n", "<Leader>/", function()
    Snacks.picker.grep()
  end, { desc = "Grep search" })
  map("n", "<Leader>gb", function()
    Snacks.picker.grep_buffers()
  end, { desc = "Grep search opened buffers" })
  map({ "n", "x" }, "<Leader>gw", function()
    Snacks.picker.grep_word()
  end, { desc = "Grep search visual selection or word" })
  map("n", "<Leader>gh", function()
    local help_dirs = vim.api.nvim_get_runtime_file("doc/*.txt", true)
    Snacks.picker.grep({ dirs = help_dirs, live = true })
  end, { desc = "Grep search help" })

  -- Git (g)
  map("n", "<Leader>gl", function()
    Snacks.picker.git_log()
  end, { desc = "Show git log" })
  map("n", "<Leader>gs", function()
    Snacks.picker.git_status()
  end, { desc = "Show git status" })
  map("n", "<Leader>gd", function()
    Snacks.picker.git_diff()
  end, { desc = "Show git diff" })
  map("n", "<Leader>gz", function()
    Snacks.lazygit()
  end, { desc = "Toggle lazygit" })

  -- Search/Show (s)
  map("n", "<Leader>sl", function()
    Snacks.picker.spelling()
  end, { desc = "Show spelling suggestions" })
  map("n", "<Leader>sn", function()
    Snacks.picker.notifications()
  end, { desc = "Show notification history" })
  map("n", '<Leader>s"', function()
    Snacks.picker.registers()
  end, { desc = "Search registers" })
  map("n", "<Leader>s/", function()
    Snacks.picker.search_history()
  end, { desc = "Search 'search' history" })
  map("n", "<Leader>sa", function()
    Snacks.picker.autocmds()
  end, { desc = "Search autocmds" })
  map("n", "<Leader>sb", function()
    Snacks.picker.lines()
  end, { desc = "Search buffer lines" })
  map("n", "<Leader>sc", function()
    Snacks.picker.commands()
  end, { desc = "Search commands" })
  map("n", "<Leader>sD", function()
    Snacks.picker.diagnostics()
  end, { desc = "Search diagnostics" })
  map("n", "<Leader>sd", function()
    Snacks.picker.diagnostics_buffer()
  end, { desc = "Search buffer diagnostics" })
  map("n", "<Leader>sh", function()
    Snacks.picker.help()
  end, { desc = "Search help pages" })
  map("n", "<Leader>sH", function()
    Snacks.picker.highlights()
  end, { desc = "Search highlights" })
  map("n", "<Leader>sj", function()
    Snacks.picker.jumps()
  end, { desc = "Search jumps" })
  map("n", "<Leader>sk", function()
    Snacks.picker.keymaps()
  end, { desc = "Search keymaps" })
  map("n", "<Leader>sm", function()
    Snacks.picker.marks()
  end, { desc = "Search marks" })
  map("n", "<Leader>sM", function()
    Snacks.picker.man()
  end, { desc = "Search man pages" })
  map("n", "<Leader>sp", function()
    Snacks.picker.projects()
  end, { desc = "Search projects" })
  map("n", "<Leader>sq", function()
    Snacks.picker.qflist()
  end, { desc = "Search quickfix list" })
  map("n", "<Leader>sr", function()
    Snacks.picker.resume()
  end, { desc = "Resume last search" })
  map("n", "<Leader>su", function()
    Snacks.picker.undo()
  end, { desc = "Search undo history" })

  -- LSP (s)
  map("n", "<Leader>ss", function()
    Snacks.picker.lsp_symbols()
  end, { desc = "Search lsp symbols" })
  map("n", "<Leader>sS", function()
    Snacks.picker.lsp_workspace_symbols()
  end, { desc = "Search lsp workspace symbols" })
end

---@type LazyPluginSpec
local snacks = {
  "folke/snacks.nvim",
  priority = 1000,
  config = function()
    vim.g.snacks_animate = false
    set_snacks_keymap()
    Snacks.setup(snacks_opts)
  end,
}

---@type neotree.Config.Base
local neotree_opts = {
  close_if_last_window = true,
  window = {
    mappings = {
      -- Jump up to parent directory on file or closed directory, or close on open directory
      ["h"] = function(state)
        local node = state.tree:get_node()
        if (node.type == "directory" or node:has_children()) and node:is_expanded() then
          state.commands.toggle_node(state)
        else
          require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
        end
      end,
      -- Open on file or closed directory, or jump down to top subdirectory on open directory
      ["l"] = function(state)
        local node = state.tree:get_node()
        if node.type == "directory" or node:has_children() then
          state.commands.toggle_node(state)
          -- if not node:is_expanded() then
          --   state.commands.toggle_node(state)
          -- else
          --   require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
          -- end
        else
          require("neo-tree.sources.filesystem.commands").open(state)
        end
      end,
      ["<space>"] = "none",
    },
  },
  filesystem = {
    window = {
      fuzzy_finder_mappings = {
        ["<C-j>"] = "move_cursor_down",
        ["<C-k>"] = "move_cursor_up",
      },
    },
  },
}

---@type LazyPluginSpec
local neotree = {
  "nvim-neo-tree/neo-tree.nvim",
  config = function()
    map("n", "<Leader>e", "<Cmd>Neotree toggle<CR>")

    require("neo-tree").setup(neotree_opts)
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
}

return { snacks, neotree }
