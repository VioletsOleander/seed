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
        -- hidden = true,
        -- ignored = true,
        follow_file = false,
        matcher = { fuzzy = true },
        -- Make sure explorer directly jump to the file after confirm,
        -- instead of remaining in the explorer window waiting for next confirm to actually jump.
        -- Other pickers does not require to set this to correctly work, maybe because they has
        -- floating window but explorer has an actual window.
        main = { current = false },
        -- Show preview in the buffer window.
        layout = { preview = "main", hidden = { "preview" } },
        actions = {
          -- Simplify the twice confirm process.
          -- Otherwise we have to press twice <CR> to actually jump to the file.
          ["confirm_in_input"] = function(picker, item, action)
            if not item then
              return
            end

            if item.dir then
              if picker.input.filter.meta.searching then
                require("snacks.explorer.actions").update(picker, { target = item.file })
              end

              require("snacks.explorer.tree"):open(item.file)
            else
              if picker.input.filter.meta.searching then
                require("snacks.explorer.actions").update(picker, { target = item.file })
              end

              -- Let picker:selected directly return current item.
              -- Otherwise picker:selected will return empty, making jump has no effect.
              local original_method = picker.selected
              picker.selected = function()
                return { item }
              end

              Snacks.picker.actions.jump(picker, item, action)

              -- picker.actions.jump will schedule the actual jump, if we do not schedule
              -- this recover too, the mock will be recovered before the execution of the actual
              -- jump.
              vim.schedule(function()
                picker.selected = original_method
              end)
            end
          end,
          -- ["confirm_debug"] = function(picker, item, action)
          --   Snacks.debug.inspect(item.pos)
          --   Snacks.debug.inspect(picker.main)
          --   require("snacks.explorer.actions").actions.confirm(picker, item, action)
          -- end,
        },
        win = {
          input = {
            keys = {
              -- Do not let Esc close explorer.
              ["<Esc>"] = false,
              ["<C-h>"] = { "toggle_hidden", mode = "i" },
              ["<C-i>"] = { "toggle_ignored", mode = "i" },
              ["<CR>"] = { "confirm_in_input", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<Esc>"] = false,
              ["<C-j>"] = false,
              ["<C-k>"] = false,
              ["<C-c>"] = false,
              ["H"] = { "toggle_hidden", mode = "n" },
              ["I"] = { "toggle_ignored", mode = "n" },
              -- ["<CR>"] = { "confirm_debug", mode = "n" },
            },
          },
        },
      },
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

local function set_snacks_keymaps()
  local map = vim.keymap.set

  -- Snacks.picker.smart will aggregate result from files, recent, buffers.
  map("n", "<Leader><Space>", function()
    Snacks.picker.smart()
  end, { desc = "Find files and buffers." })

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
