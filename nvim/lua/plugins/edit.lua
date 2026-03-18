-- edit
local nvim_autopairs = {
	"windwp/nvim-autopairs",
	cond = not vim.g.vscode,
	opts = {},
	event = "InsertEnter",
}

local nvim_surround = {
	"kylechui/nvim-surround",
	version = "^3.0.0",
	opts = {},
	event = "VeryLazy",
}

-- motion
local nvim_spider = {
	"chrisgrieser/nvim-spider",
	keys = {
		{
			"zw",
			function()
				require("spider").motion("w")
			end,
			mode = { "n", "o", "x" },
		},
		{
			"ze",
			function()
				require("spider").motion("e")
			end,
			mode = { "n", "o", "x" },
		},
		{
			"zb",
			function()
				require("spider").motion("b")
			end,
			mode = { "n", "o", "x" },
		},
		{
			"zge",
			function()
				require("spider").motion("ge")
			end,
			mode = { "n", "o", "x" },
		},
	},
}

local flash_nvim = {
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
			function()
				require("flash").jump()
			end,
			mode = { "n", "o", "x" },
			desc = "Flash Jump Mode (Jump to any visible position in current screen)",
		},
		{
			"<Leader>S",
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

local flash_zh_nvim = {
	"rainzm/flash-zh.nvim",
	dependencies = { "folke/flash.nvim" },
	keys = {
		{
			"gz",
			function()
				require("flash-zh").jump({ chinese_only = true })
			end,
			mode = { "n", "x", "o" },
			desc = "Flash Jump Mode for Chinese",
		},
	},
}

-- textobject
local mini_ai = {
	"nvim-mini/mini.ai",
	version = "*",
	opts = {
		-- disable mini.ai built-in textobjects
		custom_textobjects = {
			f = false,
			c = false,
			a = false,
			t = false,
		},
		search_method = "cover",
	},
	event = "VeryLazy",
}

local nvim_treesitter = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
}

local nvim_treesitter_textobjects = {
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
		-- f for functions
		{
			"af",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
			end,
			mode = { "x", "o" },
			desc = "Select around function",
		},
		{
			"if",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
			end,
			mode = { "x", "o" },
			desc = "Select inner function",
		},
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
			"ac",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
			end,
			mode = { "x", "o" },
			desc = "Select around class",
		},
		{
			"ic",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
			end,
			mode = { "x", "o" },
			desc = "Select inner class",
		},
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
			"aa",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
			end,
			mode = { "x", "o" },
			desc = "Select around parameter",
		},
		{
			"ia",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
			end,
			mode = { "x", "o" },
			desc = "Select inner parameter",
		},
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
				require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
			end,
			mode = "n",
			desc = "Swap previous parameter",
		},
		-- k for block
		{
			"ak",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@block.outer", "textobjects")
			end,
			mode = { "x", "o" },
			desc = "Select around block",
		},
		{
			"ik",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@block.inner", "textobjects")
			end,
			mode = { "x", "o" },
			desc = "Select inner block",
		},
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
			"]l",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@loop.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to next loop start",
		},
		{
			"[l",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@loop.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to previous loop start",
		},
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
		-- conditional
		{
			"]i", -- i for if
			function()
				require("nvim-treesitter-textobjects.move").goto_next("@conditional.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to next conditional",
		},
		{
			"[i", -- i for if
			function()
				require("nvim-treesitter-textobjects.move").goto_previous("@conditional.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Go to previous conditional",
		},
		-- s for scope (function, class, loop, etc.)
		{
			"as",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
			end,
			mode = { "x", "o" },
			desc = "Select around scope",
		},
	},
}

return {
	nvim_autopairs,
	nvim_surround,
	nvim_spider,
	flash_nvim,
	flash_zh_nvim,
	nvim_treesitter,
	nvim_treesitter_textobjects,
}
