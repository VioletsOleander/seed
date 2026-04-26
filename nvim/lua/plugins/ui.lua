local treesitter_context = {
	"nvim-treesitter/nvim-treesitter-context",
	cond = not vim.g.vscode,
	event = { "BufReadPost", "BufNewFile" },
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	opts = {},
}

local mini_icons = {
	"nvim-mini/mini.icons",
	cond = not vim.g.vscode,
	event = "VeryLazy",
	opts = {},
}

return { treesitter_context, mini_icons }
