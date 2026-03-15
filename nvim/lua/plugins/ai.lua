return {
	{
		"zbirenbaum/copilot.lua",
		cond = not vim.g.vscode,
		opts = {},
		cmd = "Copilot",
	},
	{
		"ggml-org/llama.vim",
		cond = not vim.g.vscode,
		init = function()
			vim.g.llama_config = { show_info = 0 }
		end,
		lazy = true,
	},
}
