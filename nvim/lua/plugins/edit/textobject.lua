---@module "lazy"

---@type LazyPluginSpec
local mini_ai = {
  "nvim-mini/mini.ai",
  version = "*",
  event = "VeryLazy",
  config = function()
    local mini_ai = require("mini.ai")
    local spec_treesitter = mini_ai.gen_spec.treesitter

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
      search_method = "cover",
      custom_textobjects = custom_textobjects,
      mappings = {
        around_next = "",
        inside_next = "",
      },
    }

    mini_ai.setup(opts)
  end,
}

---@type LazyPluginSpec
local nvim_treesitter = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
}

---@type LazyPluginSpec
local nvim_treesitter_textobjects = {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  event = "VeryLazy",
  init = function()
    -- Disable built-in ftplugin mappings to avoid conflicts.
    vim.g.no_python_maps = true
    vim.g.no_rust_maps = true
  end,
  config = function()
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
    vim.keymap.set({ "n", "x", "o" }, "g;", ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ "n", "x", "o" }, "g,", ts_repeat_move.repeat_last_move_previous)

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
  end,
}

return { mini_ai, nvim_treesitter, nvim_treesitter_textobjects }
