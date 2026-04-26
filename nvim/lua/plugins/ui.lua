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

local gitsigns = {
	"lewis6991/gitsigns.nvim",
	cond = not vim.g.vscode,
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signs_staged = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
	},
}

return { treesitter_context, mini_icons, gitsigns }
