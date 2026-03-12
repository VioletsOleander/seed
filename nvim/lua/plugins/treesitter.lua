return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        -- consider use treesitter-textobjects and highlights for some
        -- files types I often operate on later
        -- now just leave it unused util I have time to configure it
        lazy = false,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        init = function()
            -- Disable entire built-in ftplugin mappings to avoid conflicts.
            -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
            -- vim.g.no_plugin_maps = true

            -- Or, disable per filetype (add as you like)
            vim.g.no_python_maps = true
            -- vim.g.no_ruby_maps = true
            -- vim.g.no_rust_maps = true
            -- vim.g.no_go_maps = true
        end,
        opts = {
            select = {
                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,
                -- You can choose the select mode (default is charwise 'v')
                --
                -- Can also be a function which gets passed a table with the keys
                -- * query_string: eg '@function.inner'
                -- * method: eg 'v' or 'o'
                -- and should return the mode ('v', 'V', or '<c-v>') or a table
                -- mapping query_strings to modes.
                selection_modes = {
                    ['@parameter.outer'] = 'v', -- charwise
                    ['@function.outer'] = 'V',  -- linewise
                    -- ['@class.outer'] = '<c-v>', -- blockwise
                },
                -- If you set this to `true` (default is `false`) then any textobject is
                -- extended to include preceding or succeeding whitespace. Succeeding
                -- whitespace has priority in order to act similarly to eg the built-in
                -- `ap`.
                --
                -- Can also be a function which gets passed a table with the keys
                -- * query_string: eg '@function.inner'
                -- * selection_mode: eg 'v'
                -- and should return true of false
                include_surrounding_whitespace = false,
            },
            move = {
                -- whether to set jumps in the jumplist
                set_jumps = true,
            },
        },
        keys = {
            -- selects
            -- f for functions
            {
                "af",
                mode = { "x", "o", },
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject(
                        "@function.outer", "textobjects")
                end,
            },
            {
                "if",
                mode = { "x", "o", },
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject(
                        "@function.inner", "textobjects")
                end,
            },
            -- c for classes
            {
                "ac",
                mode = { "x", "o", },
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject(
                        "@class.outer", "textobjects")
                end,
            },
            {
                "ic",
                mode = { "x", "o", },
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject(
                        "@class.inner", "textobjects")
                end,
            },
            -- a for arguments (parameters)
            {
                "aa",
                mode = { "x", "o", },
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject(
                        "@parameter.outer", "textobjects")
                end,
            },
            {
                "ia",
                mode = { "x", "o", },
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject(
                        "@parameter.inner", "textobjects")
                end,
            },
            -- moves: goto next/previous
            -- function
            {
                "]f",
                mode = { "n", "x", "o", },
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start(
                        "@function.outer", "textobjects")
                end,
                desc = "Next function start",
            },
            {
                "[f",
                mode = { "n", "x", "o", },
                function()
                    require("nvim-treesitter-textobjects.move")
                        .goto_previous_start("@function.outer", "textobjects")
                end,
                desc = "Prev function start",
            },
            -- class
            {
                "]c",
                mode = { "n", "x", "o", },
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start(
                        "@class.outer", "textobjects")
                end,
                desc = "Next class start",
            },
            {
                "[c",
                mode = { "n", "x", "o", },
                function()
                    require("nvim-treesitter-textobjects.move")
                        .goto_previous_start("@class.outer", "textobjects")
                end,
                desc = "Prev class start",
            },
            -- loop
            {
                "]l",
                mode = { "n", "x", "o", },
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start(
                        { "@loop.inner", "@loop.outer", }, "textobjects")
                end,
                desc = "Next loop start",
            },
            {
                "[l",
                mode = { "n", "x", "o", },
                function()
                    require("nvim-treesitter-textobjects.move")
                        .goto_previous_start({ "@loop.inner", "@loop.outer", }, "textobjects")
                end,
                desc = "Prev loop start",
            },
            -- conditional
            {
                "]i", -- i for if
                mode = { "n", "x", "o", },
                function()
                    require("nvim-treesitter-textobjects.move").goto_next(
                        "@conditional.outer", "textobjects")
                end,
                desc = "Next conditional",
            },
            {
                "[i", -- i for if
                mode = { "n", "x", "o", },
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous(
                        "@conditional.outer", "textobjects")
                end,
                desc = "Prev conditional",
            },
            {
                "]a",
                mode = { "n", "x", "o", },
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start(
                        "@parameter.inner", "textobjects")
                end,
                desc = "Next parameter start",
            },
            {
                "[a",
                mode = { "n", "x", "o", },
                function()
                    require("nvim-treesitter-textobjects.move")
                        .goto_previous_start("@parameter.inner", "textobjects")
                end,
                desc = "Prev parameter start",
            },
        },
    },
}
