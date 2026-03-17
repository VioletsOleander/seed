return {
	{
		"windwp/nvim-autopairs",
		cond = not vim.g.vscode,
		opts = {},
		event = "InsertEnter",
	},
	{
		"kylechui/nvim-surround",
		version = "^3.0.0",
		opts = {},
		event = "VeryLazy",
	},
	{
		"nvim-mini/mini.ai",
		version = "*",
		opts = {
			custom_textobjects = {
				f = false,
				c = false,
			},
		},
		event = "VeryLazy",
	},
	{
		"folke/flash.nvim",
		opts = {
			modes = {
				search = {
					enabled = true,
				},
				-- flash does not support disable highlight for char mode
				-- so use vim.sneak as alternative for char mode
				char = {
					enabled = true,
					keys = { "f", "F", "t", "T", ";", "," },
					char_actions = function(motion)
						return {
							[";"] = "next",
							[","] = "prev",
						}
					end,
					highlight = {
						backdrop = false,
					},
				},
			},
		},
		event = "VeryLazy",
		keys = {
			{
				"<Leader>s",
				mode = { "n", "o", "x" },
				function()
					require("flash").jump()
				end,
				desc = "Flash Jump Mode (Jump to any visible position in current screen)",
			},
			{
				"<Leader>S",
				mode = { "n", "o", "x" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter Mode (Jump to any syntax node in current screen)",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Flash Remote Mode (Perform any motion like jump, treesitter etc. "
					.. "The operator will be executed to the target position, "
					.. "and original position will be jumped back.",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Flash Treesitter Search Mode "
					.. "(Jump to the syntax node containing searched pattern in current screen)",
			},
		},
	},
	{
		"rainzm/flash-zh.nvim",
		dependencies = { "folke/flash.nvim" },
		keys = {
			{
				"gz",
				mode = { "n", "x", "o" },
				function()
					require("flash-zh").jump({ chinese_only = true })
				end,
				desc = "Flash Jump Mode for Chinese",
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
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
				lookahead = true,
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
					-- ['@class.outer'] = '<c-v>', -- blockwise
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
			-- selects
			-- f for functions
			{
				"af",
				mode = { "x", "o" },
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
				end,
				desc = "Select around function",
			},
			{
				"if",
				mode = { "x", "o" },
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
				end,
				desc = "Select inner function",
			},
			-- c for classes
			{
				"ac",
				mode = { "x", "o" },
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
				end,
				desc = "Select around class",
			},
			{
				"ic",
				mode = { "x", "o" },
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
				end,
				desc = "Select inner class",
			},
			-- a for arguments (parameters)
			{
				"aa",
				mode = { "x", "o" },
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
				end,
				desc = "Select around parameter",
			},
			{
				"ia",
				mode = { "x", "o" },
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
				end,
				desc = "Select inner parameter",
			},
			-- s for scope (function, class, loop, etc.)
			{
				"as",
				mode = { "x", "o" },
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
				end,
				desc = "Select around scope",
			},
			-- k for block
			{
				"ak",
				mode = { "x", "o" },
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@block.outer", "textobjects")
				end,
				desc = "Select around block",
			},
			{
				"ik",
				mode = { "x", "o" },
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@block.inner", "textobjects")
				end,
				desc = "Select inner block",
			},
			-- swap next/previous parameter
			{
				"<leader>l", -- right
				mode = "n",
				function()
					require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
				end,
				desc = "Swap next parameter",
			},
			{
				"<leader>h", -- left
				mode = "n",
				function()
					require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
				end,
				desc = "Swap previous parameter",
			},
			-- moves: goto next/previous
			-- function
			{
				"]f",
				mode = { "n", "x", "o" },
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
				end,
				desc = "Go to next function start",
			},
			{
				"[f",
				mode = { "n", "x", "o" },
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
				end,
				desc = "Go to previous function start",
			},
			{
				"]F",
				mode = { "n", "x", "o" },
				function()
					require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
				end,
				desc = "Go to next function end",
			},
			{
				"[F",
				mode = { "n", "x", "o" },
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
				end,
				desc = "Go to previous function end",
			},
			-- class
			{
				"]c",
				mode = { "n", "x", "o" },
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
				end,
				desc = "Go to next class start",
			},
			{
				"[c",
				mode = { "n", "x", "o" },
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
				end,
				desc = "Go to previous class start",
			},
			{
				"]C",
				mode = { "n", "x", "o" },
				function()
					require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
				end,
				desc = "Go to next class end",
			},
			{
				"[C",
				mode = { "n", "x", "o" },
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
				end,
				desc = "Go to previous class end",
			},
			-- loop
			{
				"]l",
				mode = { "n", "x", "o" },
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@loop.outer", "textobjects")
				end,
				desc = "Go to next loop start",
			},
			{
				"[l",
				mode = { "n", "x", "o" },
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start("@loop.outer", "textobjects")
				end,
				desc = "Go to previous loop start",
			},
			{
				"]L",
				mode = { "n", "x", "o" },
				function()
					require("nvim-treesitter-textobjects.move").goto_next_end("@loop.outer", "textobjects")
				end,
				desc = "Go to next loop end",
			},
			{
				"[L",
				mode = { "n", "x", "o" },
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_end("@loop.outer", "textobjects")
				end,
				desc = "Go to previous loop end",
			},
			-- block
			{
				"]b",
				mode = { "n", "x", "o" },
				function()
					require("nvim-treesitter-textobjects.move").goto_next_end("@block.outer", "textobjects")
				end,
				desc = "Go to next block end",
			},
			{
				"[b",
				mode = { "n", "x", "o" },
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_end("@block.outer", "textobjects")
				end,
				desc = "Go to previous block end",
			},
			{
				"]B",
				mode = { "n", "x", "o" },
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@block.outer", "textobjects")
				end,
				desc = "Go to next block start",
			},
			{
				"[B",
				mode = { "n", "x", "o" },
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start("@block.outer", "textobjects")
				end,
				desc = "Go to previous block start",
			},
			-- conditional
			{
				"]i", -- i for if
				mode = { "n", "x", "o" },
				function()
					require("nvim-treesitter-textobjects.move").goto_next("@conditional.outer", "textobjects")
				end,
				desc = "Go to next conditional",
			},
			{
				"[i", -- i for if
				mode = { "n", "x", "o" },
				function()
					require("nvim-treesitter-textobjects.move").goto_previous("@conditional.outer", "textobjects")
				end,
				desc = "Go to previous conditional",
			},
			-- parameter/argument
			{
				"]a",
				mode = { "n", "x", "o" },
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.inner", "textobjects")
				end,
				desc = "Go to next parameter start",
			},
			{
				"[a",
				mode = { "n", "x", "o" },
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.inner", "textobjects")
				end,
				desc = "Go to previous parameter start",
			},
		},
	},
}
