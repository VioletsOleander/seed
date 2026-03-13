return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		cond = not vim.g.vscode,
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		cmd = "Telescope",
		opts = {
			defaults = {
				mappings = {
					["i"] = {
						["jj"] = { "<Esc>", type = "command" },
						["<Leader>c"] = "close",
						["<C-j>"] = "move_selection_next",
						["<C-k>"] = "move_selection_previous",
						["<Leader>h"] = "file_split",
						["<Leader>v"] = "file_vsplit",
					},
					["n"] = {
						["<Leader>c"] = "close",
						["<C-j>"] = "move_selection_next",
						["<C-k>"] = "move_selection_previous",
						["<Leader>h"] = "file_split",
						["<Leader>v"] = "file_vsplit",
					},
				},
			},
		},
		keys = {
			{
				"<Leader>ff",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Find Files",
			},
			{
				"<Leader>fg",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Live Grep",
			},
			{
				"<Leader>fb",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Buffers",
			},
			{
				"<Leader>fh",
				function()
					require("telescope.builtin").help_tags()
				end,
				desc = "Help Tags",
			},
			{
				"<Leader>fo",
				function()
					require("telescope.builtin").oldfiles()
				end,
				desc = "Old Files",
			},
			{
				"<Leader>fc",
				function()
					require("telescope.builtin").commands()
				end,
				desc = "Commands",
			},
			{
				"<Leader>fk",
				function()
					require("telescope.builtin").keymaps()
				end,
				desc = "Keymaps",
			},
			{
				"<Leader>fd",
				function()
					require("telescope.builtin").diagnostics()
				end,
				desc = "Diagnostics",
			},
			{
				"<Leader>fr",
				function()
					require("telescope.builtin").resume()
				end,
				desc = "Resume Search",
			},
		},
	},
	{
		"mikavilpas/yazi.nvim",
		version = "*", -- use the latest stable version
		cond = not vim.g.vscode,
		event = "VeryLazy",
		dependencies = {
			{ "nvim-lua/plenary.nvim", lazy = true },
		},
		opts = {
			-- if you want to open yazi instead of netrw, see below for more info
			open_for_directories = true,
			keymaps = {
				show_help = "?",
				-- open_file_in_vertical_split = "<Leader>v",
				-- open_file_in_horizontal_split = "<Leader>h",
			},
		},
		-- if you use `open_for_directories=true`, this is recommended
		init = function()
			-- mark netrw as loaded so it's not loaded at all.
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
		keys = {
			{
				"<Leader>-", -- <Leader> -
				mode = { "n", "v" },
				function()
					vim.cmd("Yazi")
				end,
				desc = "Open yazi at the current file",
			},
			{
				-- Open in the current working directory
				"<Leader>=", -- <Leader> =
				function()
					vim.cmd("Yazi cwd")
				end,
				desc = "Open the file manager in nvim's working directory",
			},
			{
				"<Leader>e",
				function()
					vim.cmd("Yazi toggle")
				end,
				desc = "Resume the last yazi session",
			},
		},
	},
}
