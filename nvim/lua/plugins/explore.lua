return {
	{
		"folke/snacks.nvim",
		cond = not vim.g.vscode,
		priority = 1000,
		opts = {
			-- make file load quicker
			bigfile = { enabled = true },
			quickfile = { enabled = true },
			-- make ui looks better
			notifier = { enabled = true, timeout = 3000 },
			input = { enabled = true },
			indent = { enabled = true },
			-- make explore easier
			dashboard = { enabled = true },
			explorer = { enabled = true, replace_netrw = true, trash = true },
			picker = {
				enabled = true,
				win = {
					input = {
						keys = {
							["<Leader>c"] = { "close", mode = { "n", "i" } },
							["/"] = "toggle_focus",
							["<C-j>"] = { "list_down", mode = { "i", "n" } },
							["<C-k>"] = { "list_up", mode = { "i", "n" } },
						},
					},
					list = {
						keys = {
							["<Leader>c"] = { "close", mode = { "n", "i" } },
							["/"] = "toggle_focus",
							["<C-j>"] = { "list_down", mode = { "i", "n" } },
							["<C-k>"] = { "list_up", mode = { "i", "n" } },
						},
					},
				},
			},
		},
		lazy = false,
		keys = {
			{
				"<Leader>e",
				function()
					Snacks.explorer()
				end,
				desc = "Toggle File Explorer",
			},
			{
				"<Leader>R",
				function()
					Snacks.rename.rename_file()
				end,
				desc = "Rename File",
			},
			{
				"<Leader>lg",
				function()
					Snacks.lazygit()
				end,
				desc = "Toggle Lazygit",
			},
			{
				"<Leader>:",
				function()
					Snacks.picker.command_history()
				end,
				desc = "Command History",
			},
			-- buffer
			{
				"<Leader>/",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Find Buffers",
			},
			{
				"<Leader>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "Delete Buffer without close its pane",
			},
			-- File/Find (f)
			{
				"<Leader><Leader>",
				function()
					Snacks.picker.smart()
				end,
				desc = "Smart Find Files",
			},
			{
				"<Leader>ff",
				function()
					Snacks.picker.files()
				end,
				desc = "Find Files",
			},
			{
				"<Leader>fc",
				function()
					Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "Find Config File",
			},
			{
				"<Leader>fr",
				function()
					Snacks.picker.recent()
				end,
				desc = "Find Recent Files",
			},
			-- Grep (g)
			{
				"<Leader>g",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep Search",
			},
			{
				"<Leader>gb",
				function()
					Snacks.picker.grep_buffers()
				end,
				desc = "Grep Search Open Buffers",
			},
			{
				"<Leader>gw",
				function()
					Snacks.picker.grep_word()
				end,
				desc = "Grep Search Visual Selection or Word",
				mode = { "n", "x" },
			},
			{
				"<Leader>gh",
				function()
					local help_dirs = vim.api.nvim_get_runtime_file("doc/*.txt", true)

					Snacks.picker.grep({
						dirs = help_dirs,
						live = true,
					})
				end,
				desc = "Grep search Help",
			},
			-- Git
			{
				"<Leader>gl",
				function()
					Snacks.picker.git_log()
				end,
				desc = "Git Log",
			},
			-- Search (s)
			{
				'<Leader>s"',
				function()
					Snacks.picker.registers()
				end,
				desc = "Search Registers",
			},
			{
				"<Leader>sh",
				function()
					Snacks.picker.search_history()
				end,
				desc = "Search History",
			},
			{
				"<Leader>sa",
				function()
					Snacks.picker.autocmds()
				end,
				desc = "Search Autocmds",
			},
			{
				"<Leader>sb",
				function()
					Snacks.picker.lines()
				end,
				desc = "Search Buffer Lines",
			},
			{
				"<Leader>sc",
				function()
					Snacks.picker.commands()
				end,
				desc = "Search Commands",
			},
			{
				"<Leader>sD",
				function()
					Snacks.picker.diagnostics()
				end,
				desc = "Search Diagnostics",
			},
			{
				"<Leader>sd",
				function()
					Snacks.picker.diagnostics_buffer()
				end,
				desc = "Search Buffer Diagnostics",
			},
			{
				"<Leader>sh",
				function()
					Snacks.picker.help()
				end,
				desc = "Search Help Pages",
			},
			{
				"<Leader>sH",
				function()
					Snacks.picker.highlights()
				end,
				desc = "Search Highlights",
			},
			{
				"<Leader>sj",
				function()
					Snacks.picker.jumps()
				end,
				desc = "Search Jumps",
			},
			{
				"<Leader>sk",
				function()
					Snacks.picker.keymaps()
				end,
				desc = "Search Keymaps",
			},
			{
				"<Leader>sm",
				function()
					Snacks.picker.marks()
				end,
				desc = "Search Marks",
			},
			{
				"<Leader>sM",
				function()
					Snacks.picker.man()
				end,
				desc = "Search Man Pages",
			},
			{
				"<Leader>sp",
				function()
					Snacks.picker.lazy()
				end,
				desc = "Search for Plugin Spec",
			},
			{
				"<Leader>sP",
				function()
					Snacks.picker.projects()
				end,
				desc = "Search Projects",
			},
			{
				"<Leader>sq",
				function()
					Snacks.picker.qflist()
				end,
				desc = "SearchQuickfix List",
			},
			{
				"<Leader>sR",
				function()
					Snacks.picker.resume()
				end,
				desc = "Search Resume",
			},
			{
				"<Leader>su",
				function()
					Snacks.picker.undo()
				end,
				desc = "Search Undo History",
			},
			-- LSP
			{
				"gd",
				function()
					Snacks.picker.lsp_definitions()
				end,
				desc = "Goto Definition",
			},
			{
				"gD",
				function()
					Snacks.picker.lsp_declarations()
				end,
				desc = "Goto Declaration",
			},
			{
				"gr",
				function()
					Snacks.picker.lsp_references()
				end,
				nowait = true,
				desc = "References",
			},
			{
				"gi",
				function()
					Snacks.picker.lsp_implementations()
				end,
				desc = "Goto Implementation",
			},
			{
				"gy",
				function()
					Snacks.picker.lsp_type_definitions()
				end,
				desc = "Goto T[y]pe Definition",
			},
		},
		init = function()
			vim.g.snacks_animate = false

			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Create some toggle mappings
					Snacks.toggle.option("spell", { name = "Spelling" }):map("<Leader>us")
					Snacks.toggle.option("wrap", { name = "Wrap" }):map("<Leader>uw")
					Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<Leader>uL")
					Snacks.toggle.diagnostics():map("<Leader>ud")
					Snacks.toggle.line_number():map("<Leader>ul")
					Snacks.toggle
						.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
						:map("<Leader>uc")
					Snacks.toggle.treesitter():map("<Leader>uT")
					Snacks.toggle
						.option("background", { off = "light", on = "dark", name = "Dark Background" })
						:map("<Leader>ub")
					Snacks.toggle.inlay_hints():map("<Leader>uh")
					Snacks.toggle.indent():map("<Leader>ug")
					Snacks.toggle.dim():map("<Leader>uD")
				end,
			})
		end,
	},
}
