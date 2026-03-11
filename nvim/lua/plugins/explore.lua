return {
    {
        'nvim-telescope/telescope.nvim',
        version = '*',
        cond = not vim.g.vscode,
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- optional but recommended
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', },
        },
        keys = {
            { "<Leader>ff", function() require("telescope.builtin").find_files() end,  desc = "Find Files", },
            { "<Leader>fg", function() require("telescope.builtin").live_grep() end,   desc = "Live Grep", },
            { "<Leader>fb", function() require("telescope.builtin").buffers() end,     desc = "Buffers", },
            { "<Leader>fh", function() require("telescope.builtin").help_tags() end,   desc = "Help Tags", },
            { "<Leader>fo", function() require("telescope.builtin").oldfiles() end,    desc = "Old Files", },
            { "<Leader>fc", function() require("telescope.builtin").commands() end,    desc = "Commands", },
            { "<Leader>fk", function() require("telescope.builtin").keymaps() end,     desc = "Keymaps", },
            { "<Leader>fd", function() require("telescope.builtin").diagnostics() end, desc = "Diagnostics", },
            { "<Leader>fr", function() require("telescope.builtin").resume() end,      desc = "Resume Search", },
        },
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cond = not vim.g.vscode,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons", -- optional, but recommended
        },
        keys = {
            { "<Leader>e", function() require("neo-tree.command").execute({ toggle = true, }) end, desc = "Toggle Explorer", },
        },
    },
}
