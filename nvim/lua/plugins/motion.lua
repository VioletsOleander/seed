return {
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
							[";"] = "right",
							[","] = "left",
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
				desc = "Flash",
			},
			{
				"<Leader>S",
				mode = { "n", "o", "x" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},
	{
		"rainzm/flash-zh.nvim",
		dependencies = { "folke/flash.nvim" },
		lazy = true,
		event = "VeryLazy",
		keys = {
			{
				"gz",
				mode = { "n", "x", "o" },
				function()
					require("flash-zh").jump({ chinese_only = true })
				end,
				desc = "Flash between Chinese",
			},
		},
	},
	{
		"justinmk/vim-sneak",
		enabled = false,
		dependencies = { "tpope/vim-repeat" },
		init = function()
			-- use smartcase and ignorecase
			vim.g["sneak#use_ic_scs"] = 1
		end,
		config = function()
			local api = vim.api

			-- disable sneak-s and sneak-S
			vim.keymap.set({ "n", "x" }, "<Plug>(Disable-Sneak-s)", "<Plug>Sneak_s")
			vim.keymap.set({ "n", "x" }, "<Plug>(Disable-Sneak-S)", "<Plug>Sneak_S")

			-- disable highlight
			local function clear_sneak_highlight()
				api.nvim_set_hl(0, "Sneak", { link = "None" })
				api.nvim_set_hl(0, "SneakCurrent", { link = "None" })
			end

			clear_sneak_highlight()

			api.nvim_create_autocmd("ColorScheme", {
				callback = clear_sneak_highlight,
			})
			api.nvim_create_autocmd("User", {
				pattern = "SneakLeave",
				callback = clear_sneak_highlight,
			})
		end,
		event = "VeryLazy",
		keys = {
			{ "f", "<Plug>Sneak_f", mode = { "n", "x", "o" }, desc = "Sneak Forward to" },
			{ "F", "<Plug>Sneak_F", mode = { "n", "x", "o" }, desc = "Sneak Backward to" },
			{ "t", "<Plug>Sneak_t", mode = { "n", "x", "o" }, desc = "Sneak Forward till" },
			{ "T", "<Plug>Sneak_T", mode = { "n", "x", "o" }, desc = "Sneak Backward till" },
		},
	},
}
