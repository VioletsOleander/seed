return {
	{
		"folke/snacks.nvim",
		cond = not vim.g.vscode,
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			dashboard = { enabled = true },
			explorer = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			notifier = {
				enabled = true,
				timeout = 3000,
			},
			picker = { enabled = true },
			quickfile = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
		},
		keys = {
			-- Top Pickers & Explorer
			{
				"<Leader><Leader>",
				function()
					Snacks.picker.smart()
				end,
				desc = "Smart Find Files",
			},
			{
				"<Leader>,",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Find Buffers",
			},
			{
				"<Leader>/",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
			},
			{
				"<Leader>:",
				function()
					Snacks.picker.command_history()
				end,
				desc = "Command History",
			},
			{
				"<Leader>n",
				function()
					Snacks.picker.notifications()
				end,
				desc = "Notification History",
			},
			{
				"<Leader>e",
				function()
					Snacks.explorer()
				end,
				desc = "Toggle File Explorer",
			},
			-- find
			{
				"<Leader>fb",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Find Buffers",
			},
			{
				"<Leader>fc",
				function()
					Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "Find Config File",
			},
			{
				"<Leader>ff",
				function()
					Snacks.picker.files()
				end,
				desc = "Find Files",
			},
			{
				"<Leader>fg",
				function()
					Snacks.picker.git_files()
				end,
				desc = "Find Git Files",
			},
			{
				"<Leader>fp",
				function()
					Snacks.picker.projects()
				end,
				desc = "Find Projects",
			},
			{
				"<Leader>fr",
				function()
					Snacks.picker.recent()
				end,
				desc = "Find Recent Files",
			},
			-- git
			{
				"<Leader>gb",
				function()
					Snacks.picker.git_branches()
				end,
				desc = "Git Branches",
			},
			{
				"<Leader>gl",
				function()
					Snacks.picker.git_log()
				end,
				desc = "Git Log",
			},
			{
				"<Leader>gL",
				function()
					Snacks.picker.git_log_line()
				end,
				desc = "Git Log Line",
			},
			{
				"<Leader>gs",
				function()
					Snacks.picker.git_status()
				end,
				desc = "Git Status",
			},
			{
				"<Leader>gS",
				function()
					Snacks.picker.git_stash()
				end,
				desc = "Git Stash",
			},
			{
				"<Leader>gd",
				function()
					Snacks.picker.git_diff()
				end,
				desc = "Git Diff (Hunks)",
			},
			{
				"<Leader>gf",
				function()
					Snacks.picker.git_log_file()
				end,
				desc = "Git Log File",
			},
			-- gh
			{
				"<Leader>gi",
				function()
					Snacks.picker.gh_issue()
				end,
				desc = "GitHub Issues (open)",
			},
			{
				"<Leader>gI",
				function()
					Snacks.picker.gh_issue({ state = "all" })
				end,
				desc = "GitHub Issues (all)",
			},
			{
				"<Leader>gp",
				function()
					Snacks.picker.gh_pr()
				end,
				desc = "GitHub Pull Requests (open)",
			},
			{
				"<Leader>gP",
				function()
					Snacks.picker.gh_pr({ state = "all" })
				end,
				desc = "GitHub Pull Requests (all)",
			},
			-- Grep
			{
				"<Leader>sg",
				function()
					Snacks.picker.grep()
				end,
				desc = "Search by Grep",
			},
			{
				"<Leader>sB",
				function()
					Snacks.picker.grep_buffers()
				end,
				desc = "Search Open Buffers by Grep",
			},
			{
				"<Leader>sw",
				function()
					Snacks.picker.grep_word()
				end,
				desc = "Search Visual Selection or Word by Grep",
				mode = { "n", "x" },
			},
			{
				"<Leader>sd",
				function()
					local help_dirs = vim.api.nvim_get_runtime_file("doc/*.txt", true)

					Snacks.picker.grep({
						dirs = help_dirs,
						live = true,
					})
				end,
				desc = "Search Help by Grep",
			},
			-- search
			{
				'<Leader>s"',
				function()
					Snacks.picker.registers()
				end,
				desc = "Search Registers",
			},
			{
				"<Leader>s/",
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
					Snacks.picker.command_history()
				end,
				desc = "Search Command History",
			},
			{
				"<Leader>sC",
				function()
					Snacks.picker.commands()
				end,
				desc = "Search Commands",
			},
			{
				"<Leader>sd",
				function()
					Snacks.picker.diagnostics()
				end,
				desc = "Search Diagnostics",
			},
			{
				"<Leader>sD",
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
				"<Leader>si",
				function()
					Snacks.picker.icons()
				end,
				desc = "Search Icons",
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
				"<Leader>sl",
				function()
					Snacks.picker.loclist()
				end,
				desc = "Search Location List",
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
			{
				"<Leader>uC",
				function()
					Snacks.picker.colorschemes()
				end,
				desc = "Colorschemes",
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
				"gI",
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
			{
				"gai",
				function()
					Snacks.picker.lsp_incoming_calls()
				end,
				desc = "C[a]lls Incoming",
			},
			{
				"gao",
				function()
					Snacks.picker.lsp_outgoing_calls()
				end,
				desc = "C[a]lls Outgoing",
			},
			{
				"<Leader>ss",
				function()
					Snacks.picker.lsp_symbols()
				end,
				desc = "LSP Symbols",
			},
			{
				"<Leader>sS",
				function()
					Snacks.picker.lsp_workspace_symbols()
				end,
				desc = "LSP Workspace Symbols",
			},
			-- Other
			{
				"<Leader>z",
				function()
					Snacks.zen()
				end,
				desc = "Toggle Zen Mode",
			},
			{
				"<Leader>Z",
				function()
					Snacks.zen.zoom()
				end,
				desc = "Toggle Zoom",
			},
			{
				"<Leader>.",
				function()
					Snacks.scratch()
				end,
				desc = "Toggle Scratch Buffer",
			},
			{
				"<Leader>S",
				function()
					Snacks.scratch.select()
				end,
				desc = "Select Scratch Buffer",
			},
			{
				"<Leader>n",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "Notification History",
			},
			{
				"<Leader>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "Delete Buffer",
			},
			{
				"<Leader>cR",
				function()
					Snacks.rename.rename_file()
				end,
				desc = "Rename File",
			},
			{
				"<Leader>gB",
				function()
					Snacks.gitbrowse()
				end,
				desc = "Git Browse",
				mode = { "n", "v" },
			},
			{
				"<Leader>gg",
				function()
					Snacks.lazygit()
				end,
				desc = "Lazygit",
			},
			{
				"<Leader>un",
				function()
					Snacks.notifier.hide()
				end,
				desc = "Dismiss All Notifications",
			},
			{
				"<c-/>",
				function()
					Snacks.terminal()
				end,
				desc = "Toggle Terminal",
			},
			{
				"<c-_>",
				function()
					Snacks.terminal()
				end,
				desc = "which_key_ignore",
			},
			{
				"]]",
				function()
					Snacks.words.jump(vim.v.count1)
				end,
				desc = "Next Reference",
				mode = { "n", "t" },
			},
			{
				"[[",
				function()
					Snacks.words.jump(-vim.v.count1)
				end,
				desc = "Prev Reference",
				mode = { "n", "t" },
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Setup some globals for debugging (lazy-loaded)
					_G.dd = function(...)
						Snacks.debug.inspect(...)
					end
					_G.bt = function()
						Snacks.debug.backtrace()
					end

					-- Override print to use snacks for `:=` command
					if vim.fn.has("nvim-0.11") == 1 then
						vim._print = function(_, ...)
							dd(...)
						end
					else
						vim.print = _G.dd
					end

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
