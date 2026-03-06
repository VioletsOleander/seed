return {
    "rainzm/flash-zh.nvim",
    event = "VeryLazy",
    dependencies = { "folke/flash.nvim" },
    keys = {
        {
            "gz",
            mode = { "n", "x", "o" },
            function() require("flash-zh").jump({ chinese_only = true }) end,
            desc = "Flash between Chinese"
        }
    }
}
