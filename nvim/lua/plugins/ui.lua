return {
	-- Colorscheme
	{
		"navarasu/onedark.nvim",
		cond = not vim.g.vscode,
		priority = 1000,
		config = function()
			require("onedark").setup({
				style = "light",
				highlights = {
					Cursor = { fg = "#526fff", bg = "#ffffff" },
				},
			})
			require("onedark").load()
		end,
		-- lazy = true,
	},
	{
		"folke/tokyonight.nvim",
		cond = not vim.g.vscode,
		priority = 1000,
		opts = {},
		lazy = true,
	},
	{
		"sainnhe/gruvbox-material",
		cond = not vim.g.vscode,
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_better_performance = 1
			vim.opt.background = "light"
		end,
		lazy = true,
	},
	-- Statusline
	{
		"nvim-treesitter/nvim-treesitter-context",
		cond = not vim.g.vscode,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {},
		event = { "BufReadPost", "BufNewFile" },
	},
}
