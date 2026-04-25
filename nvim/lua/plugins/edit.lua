-- Basic edit
local nvim_surround = {
	"kylechui/nvim-surround",
	event = { "BufReadPre", "BufNewFile" },
}

local nvim_autopair = {
	"windwp/nvim-autopairs",
	cond = not vim.g.vscode,
	event = "InsertEnter",
	opts = {},
}

-- Motion
local flash_nvim = {
	"folke/flash.nvim",
	config = function()
		local flash = require("flash")
		local map = vim.keymap.set

		map({ "n", "o", "x" }, "s", flash.jump, { desc = "jump to any visible position in current screen" })

		map({ "n", "o", "x" }, "<leader>s", flash.treesitter, { desc = "jump to any syntax node in current screen" })

		map({ "o" }, "r", flash.remote, {
			desc = "perform any motion like jump, treesitter etc. "
				.. "the operator will be executed to the target position, "
				.. "and original position will be jumped back.",
		})

		map(
			{ "o", "x" },
			"r",
			flash.treesitter_search,
			{ desc = "jump to the syntax node containing searched pattern in current screen" }
		)

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

-- Textobject
local mini_ai = {
	"nvim-mini/mini.ai",
	version = "*",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local mini_ai = require("mini.ai")
		local spec_treesitter = mini_ai.gen_spec.treesitter

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

		local opts = {
			n_lines = 500,
			search_method = "cover_or_next",
			custom_textobjects = custom_textobjects,
		}

		mini_ai.setup(opts)
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
		-- Disable built-in ftplugin mappings to avoid conflicts.
		vim.g.no_python_maps = true
		vim.g.no_rust_maps = true
	end,
	config = function()
		local map = vim.keymap.set
		local treesitter_textobjects = require("nvim-treesitter-textobjects")

		-- Move
		local move = treesitter_textobjects.move

		--- Helper functions to set motion keymaps
		---
		---@param args {query: string, name: string, lower: string, upper: string}
		local function map_motion(args)
			-- ]lower to next start
			map({ "n", "x", "o" }, "]" .. args.lower, function()
				move.goto_next_start(args.query, "textobjects")
			end, { desc = "Go to next " .. args.name .. " start" })

			-- [lower to previous start
			map({ "n", "x", "o" }, "[" .. args.lower, function()
				move.goto_previous_start(args.query, "textobjects")
			end, { desc = "Go to previous " .. args.name .. " start" })

			-- ]upper to next end
			map({ "n", "x", "o" }, "]" .. args.upper, function()
				move.goto_next_start(args.query, "textobjects")
			end, { desc = "Go to next " .. args.name .. " end" })

			-- [upper to previous end
			map({ "n", "x", "o" }, "[" .. args.upper, function()
				move.goto_previous_start(args.query, "textobjects")
			end, { desc = "Go to previous " .. args.name .. " end" })
		end

		-- f for function
		map_motion({ query = "@function.outer", name = "function", lower = "f", upper = "F" })
		-- c for function
		map_motion({ query = "@class.outer", name = "class", lower = "c", upper = "C" })
		-- a for function
		map_motion({ query = "@parameter.outer", name = "parameter", lower = "a", upper = "A" })
		-- v for call/invocation
		map_motion({ query = "@call.outer", name = "call", lower = "v", upper = "V" })
		-- k for block
		map_motion({ query = "@block.outer", name = "block", lower = "k", upper = "K" })
		-- l for loop
		map_motion({ query = "@loop.outer", name = "loop", lower = "l", upper = "L" })

		-- Swap
		local swap = require("nvim-treesitter-textobjects.swap")
		-- l for left
		map({ "n" }, "<Leader>l", function()
			swap.swap_next("@parameter.inner")
		end, { desc = "Swap next parameter" })
		-- r for right
		map({ "n" }, "<Leader>h", function()
			swap.swap_previous("@parameter.inner")
		end, { desc = "Swap next parameter" })

		local opts = {
			select = {
				lookahead = false,
				selection_modes = {
					["@parameter.outer"] = "v", -- charwise
					["@function.outer"] = "V", -- linewise
					-- ["@class.outer"] = "<c-v>", -- blockwise
				},
				include_surrounding_whitespace = false,
			},
			move = { set_jumps = true },
		}

		treesitter_textobjects.setup(opts)
	end,
}

-- Completion
local copilot = {
	"github/copilot.vim",
	cond = not vim.g.vscode,
	cmd = "Copilot",
}

local blink_cmp = {
	"saghen/blink.cmp",
	cond = not vim.g.vscode,
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = { "rafamadriz/friendly-snippets" },
	version = "1.*",
	opts = {
		keymap = {
			preset = "default",
			["<Tab>"] = { "select_and_accept", "fallback" },
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
		},
		cmdline = {
			keymap = {
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
			},
		},
		appearance = { nerd_font_variant = "mono" },
		completion = { documentation = { auto_show = false } },
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}

if vim.g.user_use_builtin_completion then
	return {
		nvim_surround,
		nvim_autopair,
		mini_ai,
		flash_nvim,
		nvim_treesitter,
		nvim_treesitter_textobjects,
		copilot,
	}
else
	return {
		nvim_surround,
		nvim_autopair,
		mini_ai,
		flash_nvim,
		nvim_treesitter,
		nvim_treesitter_textobjects,
		copilot,
		blink_cmp,
	}
end
