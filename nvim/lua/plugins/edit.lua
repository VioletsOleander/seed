-- edit
local nvim_autopairs = {
	"windwp/nvim-autopairs",
	cond = not vim.g.vscode,
	event = "InsertEnter",
	opts = {},
}

local nvim_surround = {
	"kylechui/nvim-surround",
	event = { "BufReadPre", "BufNewFile" },
}

-- motion
local flash_nvim = {
	"folke/flash.nvim",
	event = "VeryLazy",
	config = function()
		local flash = require("flash")

		vim.keymap.set({ "n", "o", "x" }, "s", function()
			flash.jump()
		end, { desc = "Flash Jump Mode (Jump to any visible position in current screen)" })

		vim.keymap.set({ "n", "o", "x" }, "<Leader>s", function()
			flash.treesitter()
		end, { desc = "Flash Treesitter Mode (Jump to any syntax node in current screen)" })

		vim.keymap.set({ "o" }, "r", function()
			flash.remote()
		end, {
			desc = "Flash Remote Mode (Perform any motion like jump, treesitter etc. "
				.. "The operator will be executed to the target position, "
				.. "and original position will be jumped back.",
		})

		vim.keymap.set({ "o", "x" }, "R", function()
			flash.treesitter_search()
		end, {
			desc = "Flash Treesitter Search Mode "
				.. "(Jump to the syntax node containing searched pattern in current screen)",
		})

		local opts = {
			modes = {
				char = {
					highlight = {
						backdrop = false,
					},
				},
			},
		}
		flash.setup(opts)
	end,
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
			o = spec_treesitter({ a = "@scope.outer", i = "@scope.inner" }),
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
	config = function()
		-- Move
		local move = require("nvim-treesitter-textobjects.move")

		---@param args {query: string, name: string, lower: string, upper: string}
		local function set_keymap(args)
			-- ]lower to next start
			vim.keymap.set({ "n", "x", "o" }, "]" .. args.lower, function()
				move.goto_next_start(args.query, "textobjects")
			end, { desc = "Go to next " .. args.name .. " start" })

			-- [lower to previous start
			vim.keymap.set({ "n", "x", "o" }, "[" .. args.lower, function()
				move.goto_next_start(args.query, "textobjects")
			end, { desc = "Go to previous " .. args.name .. " start" })

			-- ]upper to next end
			vim.keymap.set({ "n", "x", "o" }, "]" .. args.upper, function()
				move.goto_next_start(args.query, "textobjects")
			end, { desc = "Go to next " .. args.name .. " end" })

			-- [upper to previous end
			vim.keymap.set({ "n", "x", "o" }, "]" .. args.upper, function()
				move.goto_next_start(args.query, "textobjects")
			end, { desc = "Go to previous " .. args.name .. " end" })
		end

		-- f for function
		set_keymap({ query = "@function.outer", name = "function", lower = "f", upper = "F" })
		-- c for function
		set_keymap({ query = "@class.outer", name = "class", lower = "c", upper = "C" })
		-- a for function
		set_keymap({ query = "@parameter.outer", name = "parameter", lower = "a", upper = "A" })
		-- v for call/invocation
		set_keymap({ query = "@call.outer", name = "call", lower = "v", upper = "V" })
		-- k for block
		set_keymap({ query = "@block.outer", name = "block", lower = "k", upper = "K" })
		-- l for loop
		set_keymap({ query = "@loop.outer", name = "loop", lower = "l", upper = "L" })

		-- Swap
		local swap = require("nvim-treesitter-textobjects.swap")
		-- l for left
		vim.keymap.set({ "n" }, "<Leader>l", function()
			swap.swap_next("@parameter.inner")
		end, { desc = "Swap next parameter" })
		-- r for right
		vim.keymap.set({ "n" }, "<Leader>h", function()
			swap.swap_previous("@parameter.inner")
		end, { desc = "Swap next parameter" })

		local opts = {
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
		}

		require("nvim-treesitter-textobjects").setup(opts)
	end,
}

return {
	nvim_autopairs,
	nvim_surround,
	mini_ai,
	flash_nvim,
	nvim_treesitter,
	nvim_treesitter_textobjects,
}
