return {
	{
		"neovim/nvim-lspconfig",
		cond = not vim.g.vscode,
		config = function()
			vim.lsp.enable({ "lua_ls", "stylua", "ty", "ruff", "yamlls", "jsonls" })
		end,
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"stevearc/conform.nvim",
		cond = not vim.g.vscode,
		opts = {
			formatters_by_ft = {
				yaml = { "prettier" },
				json = { "prettier" },
			},
		},
		ft = { "yaml", "json" },
	},
	{
		"folke/lazydev.nvim",
		cond = not vim.g.vscode,
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
		ft = "lua",
	},
}
