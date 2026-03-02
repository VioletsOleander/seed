return {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
        modes = {
            search = {
                enabled = true,
            },
            char = {
                enabled = false,
                keys = { "f", "F", "t", "T" },
                char_actions = function(motion)
                    return {
                        [";"] = "next", -- set to `right` to always go right
                        [","] = "prev", -- set to `left` to always go left
                    }
                end,
            }
        },
    },
    keys = {
        { "<Leader>s", mode = { "n", "o", "x" }, function() require("flash").jump() end,              desc = "Flash" },
        { "<Leader>S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
        { "r",         mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
        { "R",         mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>",     mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
}
