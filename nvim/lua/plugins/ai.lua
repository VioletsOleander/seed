return {
	{
		"github/copilot.vim",
		cond = not vim.g.vscode,
		event = "InsertEnter",
	},
	{
		"ggml-org/llama.vim",
		cond = not vim.g.vscode,
		lazy = true,
		init = function()
			vim.g.llama_config = { show_info = 0 }
		end,
	},
}
