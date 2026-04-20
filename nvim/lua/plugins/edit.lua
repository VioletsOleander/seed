-- edit
local nvim_autopairs = {
	"windwp/nvim-autopairs",
	cond = not vim.g.vscode,
	event = "InsertEnter",
	opts = {},
}

local nvim_surround = {
	"kylechui/nvim-surround",
	version = "^3.0.0",
	event = { "BufReadPre", "BufNewFile" },
	opts = {},
}

-- motion
local flash_nvim = {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {
		modes = {
			char = {
				highlight = {
					backdrop = false,
				},
			},
		},
	},
	keys = {
		{
			"s",
			function()
				require("flash").jump()
			end,
			mode = { "n", "o", "x" },
			desc = "Flash Jump Mode (Jump to any visible position in current screen)",
		},
		{
			"<Leader>s",
			function()
				require("flash").treesitter()
			end,
			mode = { "n", "o", "x" },
			desc = "Flash Treesitter Mode (Jump to any syntax node in current screen)",
		},
		{
			"r",
			function()
				require("flash").remote()
			end,
			mode = "o",
			desc = "Flash Remote Mode (Perform any motion like jump, treesitter etc. "
				.. "The operator will be executed to the target position, "
				.. "and original position will be jumped back.",
		},
		{
			"R",
			function()
				require("flash").treesitter_search()
			end,
			mode = { "o", "x" },
			desc = "Flash Treesitter Search Mode "
				.. "(Jump to the syntax node containing searched pattern in current screen)",
		},
	},
}

-- textobject
local mini_ai = {
	"nvim-mini/mini.ai",
	version = "*",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local spec_treesitter = require("mini.ai").gen_spec.treesitter

		local custom_textobjects = {
			-- conditional (if)
			i = spec_treesitter({ a = "@conditional.outer", i = "@conditional.inner" }),
			-- scope
			s = spec_treesitter({ a = "@scope.outer", i = "@scope.inner" }),
			-- loop
			l = spec_treesitter({ a = "@loop.outer", i = "@loop.inner" }),
			-- block
			k = spec_treesitter({ a = "@block.outer", i = "@block.inner" }),
			-- function
			f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
			-- class
			c = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
			-- parameter/argument
			a = spec_treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
			-- call/invocation
			v = spec_treesitter({ a = "@call.outer", i = "@call.inner" }),
		}

		require("mini.ai").setup({
			n_lines = 500,
			search_method = "cover_or_next",
			custom_textobjects = custom_textobjects,
		})
	end,
}

local nvim_treesitter = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
}

local nvim_treesitter_textobjects = {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	event = { "BufReadPre", "BufNewFile" },
	init = function()
		-- Disable entire built-in ftplugin mappings to avoid conflicts.
		-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
		-- vim.g.no_plugin_maps = true

		-- Or, disable per filetype (add as you like)
		vim.g.no_python_maps = true
		-- vim.g.no_ruby_maps = true
		-- vim.g.no_rust_maps = true
		-- vim.g.no_go_maps = true
	end,
	opts = {
		select = {
			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = false,
			-- You can choose the select mode (default is charwise 'v')
			--
			-- Can also be a function which gets passed a table with the keys
			-- * query_string: eg '@function.inner'
			-- * method: eg 'v' or 'o'
			-- and should return the mode ('v', 'V', or '<c-v>') or a table
			-- mapping query_strings to modes.
			selection_modes = {
				["@parameter.outer"] = "v", -- charwise
				["@function.outer"] = "V", -- linewise
				-- ["@class.outer"] = "<c-v>", -- blockwise
			},
			-- If you set this to `true` (default is `false`) then any textobject is
			-- extended to include preceding or succeeding whitespace. Succeeding
			-- whitespace has priority in order to act similarly to eg the built-in
			-- `ap`.
			--
			-- Can also be a function which gets passed a table with the keys
			-- * query_string: eg '@function.inner'
			-- * selection_mode: eg 'v'
			-- and should return true of false
			include_surrounding_whitespace = false,
		},
		move = {
			-- whether to set jumps in the jumplist
			set_jumps = true,
		},
	},
	keys = {
		-- f for functions
		{
			"]f",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to next function start",
		},
		{
			"[f",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to previous function start",
		},
		{
			"]F",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to next function end",
		},
		{
			"[F",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to previous function end",
		},
		-- c for classes
		{
			"]c",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to next class start",
		},
		{
			"[c",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to previous class start",
		},
		{
			"]C",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to next class end",
		},
		{
			"[C",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to previous class end",
		},
		-- a for arguments (parameters)
		{
			"]a",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.inner", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to next parameter start",
		},
		{
			"[a",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.inner", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to previous parameter start",
		},
		{
			"]A",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to next parameter start",
		},
		{
			"[A",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to previous parameter start",
		},
		-- v for call (invocation)
		{
			"]v",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@call.inner", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to next procedure call start",
		},
		{
			"[v",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@call.inner", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to previous procedure call start",
		},
		{
			"]V",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@call.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to next procedure call start",
		},
		{
			"[V",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@call.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to previous procedure call start",
		},
		-- swap next/previous parameter
		{
			"<leader>l", -- right
			function()
				require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
			end,
			mode = "n",
			desc = "Swap next parameter",
		},
		{
			"<leader>h", -- left
			function()
				require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
			end,
			mode = "n",
			desc = "Swap previous parameter",
		},
		-- k for block
		{
			"]k",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@block.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to next block end",
		},
		{
			"[k",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@block.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to previous block end",
		},
		{
			"]K",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@block.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to next block start",
		},
		{
			"[K",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@block.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to previous block start",
		},
		-- loop
		{
			"]L",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@loop.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to next loop end",
		},
		{
			"[L",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@loop.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to previous loop end",
		},
	},
}

return {
	nvim_autopairs,
	nvim_surround,
	mini_ai,
	flash_nvim,
	nvim_treesitter,
	nvim_treesitter_textobjects,
}
