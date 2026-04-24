local lsp_config = {
	"neovim/nvim-lspconfig",
	cond = not vim.g.vscode,
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		vim.lsp.enable({ "lua_ls", "stylua", "ty", "ruff", "yamlls", "jsonls", "rust_analyzer" })
	end,
}

local conform = {
	"stevearc/conform.nvim",
	cond = not vim.g.vscode,
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_format" },
			yaml = { "prettier" },
			json = { "prettier" },
			toml = { "taplo" },
			rust = { "rustfmt" },
		},
		format_on_save = {
			lsp_format = "fallback",
			timeout_ms = 3000,
		},
	},
}

local lazydev = {
	"folke/lazydev.nvim",
	cond = not vim.g.vscode,
	ft = "lua",
	opts = {
		library = {
			-- See the configuration section for more details
			-- Load luvit types when the `vim.uv` word is found
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	},
}

return {
	lsp_config,
	conform,
	lazydev,
}
