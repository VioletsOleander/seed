return {
	{
		"kylechui/nvim-surround",
		version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
		opts = {},
		event = "VeryLazy",
	},
	{
		"nvim-mini/mini.ai",
		version = "*",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		opts = {
			custom_textobjects = {
				f = false,
				c = false,
			},
		},
	},
}
