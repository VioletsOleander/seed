return {
	-- Colorscheme
	{
		"olimorris/onedarkpro.nvim",
		cond = not vim.g.vscode,
		priority = 1000,
		config = function()
			local gray = "#aaaaaa"
			local light_gray = "#dddddd"
			local lighter_gray = "#efefef"

			local white = "#ffffff"
			local dark_white = "#f9f9f9"
			local darker_white = "#f0f0f0"

			local black = "#1a1a1a"
			local light_black = "#2a2c33"

			local green = "#378433"

			local blue = "#2f5af3"
			local light_blue = "#376af7"
			local lighter_blue = "#c8d3f3"

			local purple = "#950095"
			local cyan = "#078378"

			local orange = "#bc6b0b"
			local red = "#d04239"

			local fg = light_black
			local bg = dark_white

			local custom_colors = {
				onelight = {
					fg = fg,
					bg = bg,
					black = black,
					white = white,
					blue = blue,
					cyan = cyan,
					green = green,
					purple = purple,
					red = red,
					yellow = "#867109",
					orange = orange,
					gray = gray,
					highlight = lighter_gray,
					comment = "#72747e",
				},
			}

			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "onelight",
				callback = function()
					-- bg for float window and widgets on it
					local float_bg = darker_white

					local highlights = {
						-- float window related
						FloatTitle = { fg = green, bg = float_bg },
						NonText = { bg = float_bg },
						NormalFloat = { bg = float_bg },
						SnacksPickerPreview = { fg = fg, bg = bg },
						SnacksPickerPrompt = { fg = blue, bg = float_bg },
						-- flash
						FlashMatch = { fg = darker_white, bg = light_blue },
						FlashCurrent = { fg = darker_white, bg = orange },
						FlashLabel = { fg = darker_white, bg = red },
						-- others
						StatusLine = { bg = darker_white },
					}

					for name, val in pairs(highlights) do
						vim.api.nvim_set_hl(0, name, val)
					end
				end,
			})

			require("onedarkpro").setup({ colors = custom_colors })
			vim.cmd("colorscheme onelight")
		end,
	},
	{
		"folke/tokyonight.nvim",
		cond = not vim.g.vscode,
		priority = 1000,
		opts = {},
		lazy = true,
	},
	{
		"catppuccin/nvim",
		cond = not vim.g.vscode,
		name = "catppuccin",
		priority = 1000,
		lazy = true,
	},
	{
		"sainnhe/gruvbox-material",
		cond = not vim.g.vscode,
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_better_performance = 1
			vim.g.gruvbox_material_background = "soft"
		end,
		lazy = true,
	},
	-- Statusline
	{
		"nvim-treesitter/nvim-treesitter-context",
		cond = not vim.g.vscode,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {},
		event = { "BufReadPost", "BufNewFile" },
	},
}
