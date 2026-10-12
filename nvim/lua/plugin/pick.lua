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
        actions = {
          -- Simplify the twice confirm process.
          -- ["confirm_in_input"] = function(picker, item, action)
          --   if not item then
          --     return
          --   end
          --
          --   if item.dir then
          --     if picker.input.filter.meta.searching then
          --       require("snacks.explorer.actions").update(picker, { target = item.file })
          --     end
          --
          --     require("snacks.explorer.tree"):show(item.file)
          --   else
          --     if picker.input.filter.meta.searching then
          --       require("snacks.explorer.actions").update(picker, { target = item.file })
          --     end
          --
          --     Snacks.debug.inspect(picker.main)
          --     Snacks.debug.inspect(Snacks.picker.util.path(item))
          --     Snacks.picker.actions.jump(picker, item, action)
          --   end
          -- end,
        },
        win = {
          input = {
            keys = {
              -- Do not let Esc close explorer.
              ["<Esc>"] = false,
              ["<C-h>"] = { "toggle_hidden", mode = "i" },
              ["<C-i>"] = { "toggle_ignored", mode = "i" },
              -- ["<CR>"] = { "confirm_in_input", mode = { "i", "n" } },
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
    Snacks.picker.command_history()
  end, { desc = "Show command history." })

  map("n", "<Leader>e", function()
    Snacks.explorer()
  end, { desc = "Toggle file explorer based on current working directory." })

  -- Buffer (b).
  map("n", "<Leader>l", function()
    Snacks.picker.buffers()
  end, { desc = "Find buffers." })

  -- File (f).
  -- Snacks.picker.smart will aggregate result from these three pickers.
  -- We aims to be precise, therefore do not map Snacks.picker.smart, but use the specific one.
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
end

---@type LazyPluginSpec
local snacks = {
  "folke/snacks.nvim",
  priority = 1000,
  config = function()
    vim.g.snacks_animate = false
    set_snacks_keymaps()
    Snacks.setup(snacks_opts)
  end,
}

return { snacks }
