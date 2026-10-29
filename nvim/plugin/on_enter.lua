local function on_enter()
  local safely = require("util").safely

  vim.pack.add({
    "https://github.com/folke/flash.nvim",
    "https://github.com/kylechui/nvim-surround",
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  })

  --- Mini.files.

  safely(function()
    require("mini.files").setup({ windows = { preview = true, width_preview = 50 } })

    vim.keymap.set("n", "<Leader>e", require("mini.files").open, { desc = "Toggle mini files." })
  end)

  --- Mini.move.

  safely(function()
    require("mini.move").setup()
  end)

  --- Mini.ai.

  safely(function()
    local spec_treesitter = require("mini.ai").gen_spec.treesitter

    local custom_textobjects = {
      -- conditional (if)
      i = spec_treesitter({ a = "@conditional.outer", i = "@conditional.inner" }),
      -- scope
      o = spec_treesitter({ a = "@scope.outer", i = "@scope.inner" }),
      -- loop
      l = spec_treesitter({ a = "@loop.outer", i = "@loop.inner" }),
      -- block
      k = spec_treesitter({ a = "@block.outer", i = "@block.inner" }),
      -- function
      f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
      -- class
      c = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
      -- parameter/argument
      a = spec_treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
      -- call/invocation
      v = spec_treesitter({ a = "@call.outer", i = "@call.inner" }),
      -- assignment
      m = spec_treesitter({ a = "@assignment.outer", i = "@assignment.inner" }),
      -- tag
      t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
    }

    local opts = {
      n_lines = 500,
      -- search_method = "cover",
      custom_textobjects = custom_textobjects,
      mappings = {
        around_next = "",
        inside_next = "",
      },
    }

    require("mini.ai").setup(opts)
  end)

  --- Nvim-treesitter-textobjects.

  safely(function()
    -- Disable built-in ftplugin mappings to avoid conflicts.
    vim.g.no_python_maps = true
    vim.g.no_rust_maps = true

    local map = vim.keymap.set

    -- Move
    local move = require("nvim-treesitter-textobjects.move")

    --- Helper functions to set motion keymaps
    ---
    ---@param args {query: string, name: string, lower: string, upper: string}
    local function map_motion(args)
      -- ]lower to next start
      map({ "n", "x", "o" }, "]" .. args.lower, function()
        move.goto_next_start(args.query, "textobjects")
      end, { desc = "Go to next " .. args.name .. " start" })

      -- [lower to previous start
      map({ "n", "x", "o" }, "[" .. args.lower, function()
        move.goto_previous_start(args.query, "textobjects")
      end, { desc = "Go to previous " .. args.name .. " start" })

      -- ]upper to next end
      map({ "n", "x", "o" }, "]" .. args.upper, function()
        move.goto_next_end(args.query, "textobjects")
      end, { desc = "Go to next " .. args.name .. " end" })

      -- [upper to previous end
      map({ "n", "x", "o" }, "[" .. args.upper, function()
        move.goto_previous_end(args.query, "textobjects")
      end, { desc = "Go to previous " .. args.name .. " end" })
    end

    -- f for function
    map_motion({ query = "@function.outer", name = "function", lower = "f", upper = "F" })
    -- c for class
    map_motion({ query = "@class.outer", name = "class", lower = "c", upper = "C" })
    -- a for argument/parameter
    map_motion({ query = "@parameter.outer", name = "parameter", lower = "a", upper = "A" })
    -- v for call/invocation
    map_motion({ query = "@call.outer", name = "call", lower = "v", upper = "V" })
    -- k for block
    map_motion({ query = "@block.outer", name = "block", lower = "k", upper = "K" })
    -- l for loop
    map_motion({ query = "@loop.outer", name = "loop", lower = "l", upper = "L" })
    -- i for conditional
    map_motion({ query = "@conditional.outer", name = "conditional", lower = "i", upper = "I" })
    -- m for assignment
    map_motion({ query = "@assignment.outer", name = "assignment", lower = "m", upper = "M" })

    -- Swap
    local swap = require("nvim-treesitter-textobjects.swap")

    -- l for left
    map({ "n" }, "<Leader>ml", function()
      swap.swap_next("@parameter.inner")
    end, { desc = "Swap next parameter" })
    -- r for right
    map({ "n" }, "<Leader>mh", function()
      swap.swap_previous("@parameter.inner")
    end, { desc = "Swap previous parameter" })

    local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

    -- Repeat movement with g; and g,
    map({ "n", "x", "o" }, "g;", ts_repeat_move.repeat_last_move_next)
    map({ "n", "x", "o" }, "g,", ts_repeat_move.repeat_last_move_previous)

    local opts = {
      -- select is done using Flash.treesitter
      -- select = {
      --   lookahead = false,
      --   selection_modes = {
      --     ["@parameter.outer"] = "v", -- charwise
      --     ["@function.outer"] = "V", -- linewise
      --     -- ["@class.outer"] = "<c-v>", -- blockwise
      --   },
      --   include_surrounding_whitespace = true,
      -- },
      move = { set_jumps = true },
    }

    require("nvim-treesitter-textobjects").setup(opts)
  end)

  --- Nvim-surround.

  safely(function()
    require("nvim-surround").setup({ move_cursor = "sticky" })
  end)

  --- Flash.

  safely(function()
    local map = vim.keymap.set

    -- Regular keymaps
    map({ "n", "o", "x" }, "s", function()
      require("flash").jump()
    end, { desc = "Jump to visible word by searching" })
    map({ "n", "o", "x" }, "<C-s>", function()
      require("flash").jump({ continue = true })
    end, { desc = "Continue last flash jump" })
    map({ "n", "o", "x" }, "gs", function()
      require("flash").treesitter()
    end, { desc = "Select visible parent treesitter node" })
    map("o", "r", function()
      require("flash").remote()
    end, { desc = "Jump to visible place by searching. Jump back after finishing operator" })
    map({ "o", "x" }, "R", function()
      require("flash").treesitter_search()
    end, { desc = "Select range by searching neighboring treesitter node" })

    -- Custom keymaps
    map({ "n", "o", "x" }, "gl", function()
      require("flash").jump({
        search = { mode = "search", max_length = 0 },
        pattern = "^",
        label = {
          after = { 0, 0 },
          format = function(opts)
            return {
              { opts.match.label1, "FlashMatch" },
              { opts.match.label2, "FlashMatch" },
            }
          end,
        },
        action = function(match, state)
          state:hide()
          require("flash").jump({
            search = { max_length = 0 },
            label = {
              format = function(opts)
                return { { opts.match.label2, "FlashMatch" } }
              end,
            },
            highlight = { matches = false },
            matcher = function(win)
              -- Limit matches to the current selected label
              return vim.tbl_filter(function(m)
                return m.label1 == match.label1 and m.win == win
              end, state.results)
            end,
            labeler = function(matches)
              for _, m in ipairs(matches) do
                m.label = m.label2
              end
            end,
          })
        end,
        labeler = function(matches, state)
          local labels = state:labels()
          for i, match in ipairs(matches) do
            -- Each 10 lines share the same first label
            match.label1 = labels[math.floor((i - 1) / 10) + 1]
            match.label2 = labels[(i - 1) % 10 + 1]
            match.label = match.label1
          end
        end,
      })
    end, { desc = "Jump to a visible line." })

    -- Customize char mode to show label for the first "f/F" match.

    local flash_char_motions = {
      f = { label = { after = true, before = false } },
      t = { label = { after = true, before = false } },
      F = {
        label = { after = false, before = true },
        jump = { inclusive = false },
        search = { forward = false },
      },
      T = {
        label = { after = false, before = true },
        jump = { inclusive = false },
        search = { forward = false },
      },
    }

    local function flash_char_new()
      local char = require("flash.plugins.char")
      local opts = require("flash.config").get({
        mode = "char",
        labeler = char.labeler,
        search = {
          multi_window = false,
          mode = char.mode(char.motion),
          max_length = 1,
        },
        prompt = { enabled = false },
      }, char.motions[char.motion])

      if not vim.fn.mode(true):find("no") then
        opts.highlight.groups.current = "Normal"
      end

      -- Exclude the motion labels so we can use them for next/prev.
      opts.labels = opts.labels:gsub(char.motion:lower(), "")
      opts.labels = opts.labels:gsub(char.motion:upper(), "")

      return require("flash.state").new(opts)
    end

    require("flash.plugins.char").motions = flash_char_motions
    require("flash.plugins.char").new = flash_char_new

    local opts = {
      labels = "asdfghjkl;qwertyuiopzxcvbnm",
      search = {
        -- The cursor will flick when search multi_window, so disable it
        multi_window = false,
        exclude = {
          "snacks_picker_input",
          "flash_prompt",
          function(win)
            return not vim.api.nvim_win_get_config(win).focusable
          end,
        },
      },
      highlight = {
        backdrop = false,
        groups = { current = "FlashMatch" },
      },
      label = { uppercase = true },
      modes = {
        char = {
          config = false,
          label = { exclude = ";hjkliardc" },
          jump_labels = true,
          highlight = { backdrop = false },
          char_actions = function(motion)
            return {
              [";"] = "right",
              [","] = "left",
              [motion:lower()] = "right",
              [motion:upper()] = "left",
            }
          end,
          jump = {
            autojump = true,
          },
        },
        treesitter = { jump = { autojump = false } },
      },
    }

    require("flash").setup(opts)
  end)
end

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  group = vim.api.nvim_create_augroup("user", { clear = false }),
  callback = function()
    vim.schedule(on_enter)
  end,
})
