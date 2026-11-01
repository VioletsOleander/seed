local function on_enter()
  local safely = require("util").safely

  vim.pack.add({
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    "https://github.com/andymass/vim-matchup",
    "https://github.com/kylechui/nvim-surround",
    "https://github.com/folke/flash.nvim",
  })

  --- Mini.files.

  safely(function()
    require("mini.files").setup({ windows = { preview = true, width_preview = 50 } })

    local show_hidden = false
    local fliters = {
      [true] = function(_)
        return true
      end,
      [false] = function(fs_entry)
        return not vim.startswith(fs_entry.name, ".")
      end,
    }

    local function split(direction)
      local cur = require("mini.files").get_explorer_state().target_window
      local new = vim.api.nvim_win_call(cur, function()
        vim.cmd(direction .. " split")
        return vim.api.nvim_get_current_win()
      end)

      require("mini.files").set_target_window(new)
      require("mini.files").go_in({ close_on_file = true })
    end

    vim.keymap.set("n", "<Leader>e", function()
      if require("mini.files").close() == nil then
        require("mini.files").open(nil, true, { content = { filter = fliters[show_hidden] } })
      end
    end, { desc = "Toggle mini files." })

    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("user", { clear = false }),
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local buf = args.data.buf_id
        local map = vim.keymap.set

        map("n", "gs", require("mini.files").synchronize, { buf = buf, desc = "Synchronize." })
        map("n", "<C-s>", function()
          split("belowright horizontal")
        end, { buf = buf, desc = "Split belowright horizontal." })
        map("n", "<C-v>", function()
          split("belowright vertical")
        end, { buf = buf, desc = "Split belowright vertical." })
        map("n", "<C-t>", function()
          split("tab")
        end, { buf = buf, desc = "Split tab." })
        map("n", "<C-l>", function()
          require("mini.files").go_in({ close_on_file = true })
        end, { buf = buf, desc = "Go in plus" })

        map("n", "g.", function()
          show_hidden = not show_hidden
          require("mini.files").refresh({ content = { filter = fliters[show_hidden] } })
        end, { buf = buf, desc = "Toggle showing hidden." })
      end,
    })
  end)

  --- Mini.move.

  safely(function()
    require("mini.move").setup()
  end)

  --- Mini.ai.

  safely(function()
    local spec_treesitter = require("mini.ai").gen_spec.treesitter

    local opts = {
      n_lines = 500,
      custom_textobjects = {
        -- function
        f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
        -- class
        c = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
        -- parameter/argument
        a = spec_treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
        -- call/invocation
        v = spec_treesitter({ a = "@call.outer", i = "@call.inner" }),
        -- loop
        o = spec_treesitter({ a = "@loop.outer", i = "@loop.inner" }),
        -- assignment
        m = spec_treesitter({ a = "@assignment.outer", i = "@assignment.inner" }),
      },
      mappings = { around_next = "", inside_next = "" },
    }

    require("mini.ai").setup(opts)
  end)

  --- Nvim-treesitter-textobjects.

  safely(function()
    vim.g.no_rust_maps = true
    vim.g.no_python_maps = true

    local map = vim.keymap.set

    local motions = {
      { query = "@function.outer", name = "function", lower = "f", upper = "F" },
      { query = "@class.outer", name = "class", lower = "c", upper = "C" },
      { query = "@class.outer", name = "class", lower = "]", upper = "[" },
      { query = "@parameter.outer", name = "parameter", lower = "a", upper = "A" }, -- a for argument
      { query = "@call.outer", name = "call", lower = "v", upper = "V" }, -- i for invocation
    }

    for _, motion in ipairs(motions) do
      -- ]lower to next start
      map({ "n", "x", "o" }, "]" .. motion.lower, function()
        require("nvim-treesitter-textobjects.move").goto_next_start(motion.query, "textobjects")
      end, { desc = "Go to next " .. motion.name .. " start" })

      -- [lower to previous start
      map({ "n", "x", "o" }, "[" .. motion.lower, function()
        require("nvim-treesitter-textobjects.move").goto_previous_start(motion.query, "textobjects")
      end, { desc = "Go to previous " .. motion.name .. " start" })

      -- ]upper to next end
      map({ "n", "x", "o" }, "]" .. motion.upper, function()
        require("nvim-treesitter-textobjects.move").goto_next_end(motion.query, "textobjects")
      end, { desc = "Go to next " .. motion.name .. " end" })

      -- [upper to previous end
      map({ "n", "x", "o" }, "[" .. motion.upper, function()
        require("nvim-treesitter-textobjects.move").goto_previous_end(motion.query, "textobjects")
      end, { desc = "Go to previous " .. motion.name .. " end" })
    end

    map(
      { "n", "x", "o" },
      "g;",
      require("nvim-treesitter-textobjects.repeatable_move").repeat_last_move_next,
      { desc = "Repeat last treesitter move to next." }
    )
    map(
      { "n", "x", "o" },
      "g,",
      require("nvim-treesitter-textobjects.repeatable_move").repeat_last_move_previous,
      { desc = "Repeat last treesitter move to previous." }
    )

    map({ "n" }, "<Leader>ml", function()
      require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
    end, { desc = "Swap next parameter" })
    map({ "n" }, "<Leader>mh", function()
      require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
    end, { desc = "Swap previous parameter" })

    require("nvim-treesitter-textobjects").setup({ move = { set_jumps = true } })
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
    map({ "o", "x" }, "gr", function()
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
