local atom_one_light = {
	"olimorris/onedarkpro.nvim",
	cond = not vim.g.vscode,
	priority = 1000,
	config = function()
		local gray = "#aaaaaa"
		local light_gray = "#dddddd"
		local lighter_gray = "#efefef"

		local white = "#ffffff"
		local dark_white = "#fafafa"
		local darker_white = "#f0f0f0"

		local black = "#2a2c33"
		local light_black = "#383a42"

		local green = "#327a2e"

		local blue = "#2153e8"
		local light_blue = "#426ce8"

		local purple = "#950095"
		local cyan = "#2e7a78"

		local orange = "#bc6b0b"
		local red = "#be342c"
		local light_red = "#d7332c"
		local yellow = "#73732b"

		local dark_pink = "#d70071"

		local fg = black
		local bg = dark_white

		local custom_colors = {
			onelight = {
				fg = fg,
				bg = bg,
				black = black,
				white = white,
				blue = light_blue,
				cyan = cyan,
				green = green,
				purple = purple,
				red = red,
				yellow = yellow,
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
					FlashMatch = { fg = dark_white, bg = light_blue },
					FlashCurrent = { fg = dark_white, bg = orange },
					FlashLabel = { fg = white, bg = dark_pink },
					-- others
					StatusLine = { bg = darker_white },
					Cursor = { fg = black, bg = gray },
				}

				for name, val in pairs(highlights) do
					vim.api.nvim_set_hl(0, name, val)
				end
			end,
		})

		require("onedarkpro").setup({ colors = custom_colors })
		vim.cmd("colorscheme onelight")
	end,
}

local gruvbox_material = {
	"sainnhe/gruvbox-material",
	cond = not vim.g.vscode,
	lazy = true,
	priority = 1000,
	config = function()
		vim.g.gruvbox_material_better_performance = 1
		vim.g.gruvbox_material_background = "medium"
		vim.cmd("colorscheme gruvbox-material")
	end,
}

local tokyo_night_day = {
	"folke/tokyonight.nvim",
	cond = not vim.g.vscode,
	lazy = true,
	priority = 1000,
	config = function()
		require("tokyonight").setup()
		vim.cmd("colorscheme tokyonight-day")
	end,
}

local treesitter_context = {
	"nvim-treesitter/nvim-treesitter-context",
	cond = not vim.g.vscode,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {},
	event = { "BufReadPost", "BufNewFile" },
}

return {
	atom_one_light,
	gruvbox_material,
	tokyo_night_day,
	treesitter_context,
}
