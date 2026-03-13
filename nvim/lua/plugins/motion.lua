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
}
