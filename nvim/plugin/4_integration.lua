-- Lsp, Formatter, Treesitter and Git integration.

vim.pack.add({
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/nvim-mini/mini.ai",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
})

local function setup_mini_ai()
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
end

local function setup_nvimtreesitter_textobjects()
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
end

local au = vim.api.nvim_create_autocmd

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

au("FileType", {
  pattern = treesitter_langauges,
  callback = function(ev)
    vim.treesitter.start(ev.buf)
  end,
})

au("PackChanged", {
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

au("VimEnter", {
  callback = function()
    vim.schedule(function()
      setup_mini_ai()
      setup_nvimtreesitter_textobjects()
    end)
  end,
})

local com = vim.api.nvim_create_user_command

com("LoadGitSigns", function()
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
end, { desc = "Load GitSigns" })
