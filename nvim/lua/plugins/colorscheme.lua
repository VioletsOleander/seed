return {
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
	},
	{
		"olimorris/onedarkpro.nvim",
		cond = not vim.g.vscode,
		priority = 1000,
		lazy = true,
	},
	{
		"folke/tokyonight.nvim",
		cond = not vim.g.vscode,
		priority = 1000,
		opts = {},
		-- config = function()
		--     vim.cmd.colorscheme('tokyonight-day')
		-- end,
	},
}
