---@module "snacks"

---@type snacks.Config
local snacks_opts = {
	-- File load
	bigfile = { enabled = true },
	quickfile = { enabled = true },
	-- UI
	notifier = { enabled = true, timeout = 3000 },
	input = { enabled = true },
	indent = { enabled = true },
	-- Picker
	explorer = { enabled = true, replace_netrw = true, trash = true },
	picker = {
		enabled = true,
		win = {
			input = {
				keys = {
					["<C-q>"] = { "close", mode = { "i", "n" } },
					["<C-j>"] = { "list_down", mode = { "i", "n" } },
					["<C-k>"] = { "list_up", mode = { "i", "n" } },
					["<Leader>v"] = { "edit_vsplit", mode = { "i", "n" } },
					["<Leader>s"] = { "edit_split", mode = { "i", "n" } },
				},
			},
			list = {
				keys = {
					["<C-q>"] = { "close", mode = { "i", "n" } },
					["<C-j>"] = { "list_down", mode = { "i", "n" } },
					["<C-k>"] = { "list_up", mode = { "i", "n" } },
					["<Leader>v"] = { "edit_vsplit", mode = { "i", "n" } },
					["<Leader>s"] = { "edit_split", mode = { "i", "n" } },
				},
			},
		},
		sources = {
			explorer = {
				hidden = true,
				ignored = true,
			},
			files = {
				hidden = true,
				ignored = true,
			},
		},
	},
}

local snacks = {
	"folke/snacks.nvim",
	cond = not vim.g.vscode,
	lazy = false,
	priority = 1000,
	config = function()
		local map = vim.keymap.set

		map("n", "<Leader>e", function()
			Snacks.explorer()
		end, { desc = "Toggle File Explorer" })
		map("n", "<Leader>R", function()
			Snacks.rename.rename_file()
		end, { desc = "Rename File" })
		map("n", "<Leader>:", function()
			Snacks.picker.command_history()
		end, { desc = "Command History" })
		map("n", "<Leader>n", function()
			Snacks.picker.notifications()
		end, { desc = "Notification History" })

		-- Buffer (b)
		map("n", "<Leader>,", function()
			Snacks.picker.buffers()
		end, { desc = "Find Buffers" })
		map("n", "<Leader>bd", function()
			Snacks.bufdelete()
		end, { desc = "Delete Buffer without close its pane" })

		-- File (f)
		map("n", "<Leader><Leader>", function()
			Snacks.picker.smart()
		end, { desc = "Smart Find Files" })
		map("n", "<Leader>ff", function()
			Snacks.picker.files()
		end, { desc = "Find Files" })
		map("n", "<Leader>fc", function()
			Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "Find Config File" })
		map("n", "<Leader>fr", function()
			Snacks.picker.recent()
		end, { desc = "Find Recent Files" })

		-- Grep (g)
		map("n", "<Leader>g", function()
			Snacks.picker.grep()
		end, { desc = "Grep Search" })
		map("n", "<Leader>gb", function()
			Snacks.picker.grep_buffers()
		end, { desc = "Grep Search Open Buffers" })
		map({ "n", "x" }, "<Leader>gw", function()
			Snacks.picker.grep_word()
		end, { desc = "Grep Search Visual Selection or Word" })
		map("n", "<Leader>gh", function()
			local help_dirs = vim.api.nvim_get_runtime_file("doc/*.txt", true)
			Snacks.picker.grep({ dirs = help_dirs, live = true })
		end, { desc = "Grep search Help" })

		-- Git (g)
		map("n", "<Leader>gl", function()
			Snacks.picker.git_log()
		end, { desc = "Git Log" })
		map("n", "<Leader>lg", function()
			Snacks.lazygit()
		end, { desc = "Toggle Lazygit" })

		-- Search (s)
		map("n", '<Leader>s"', function()
			Snacks.picker.registers()
		end, { desc = "Search Registers" })
		map("n", "<Leader>s/", function()
			Snacks.picker.search_history()
		end, { desc = "Search History" })
		map("n", "<Leader>sa", function()
			Snacks.picker.autocmds()
		end, { desc = "Search Autocmds" })
		map("n", "<Leader>sb", function()
			Snacks.picker.lines()
		end, { desc = "Search Buffer Lines" })
		map("n", "<Leader>sc", function()
			Snacks.picker.commands()
		end, { desc = "Search Commands" })
		map("n", "<Leader>sD", function()
			Snacks.picker.diagnostics()
		end, { desc = "Search Diagnostics" })
		map("n", "<Leader>sd", function()
			Snacks.picker.diagnostics_buffer()
		end, { desc = "Search Buffer Diagnostics" })
		map("n", "<Leader>sh", function()
			Snacks.picker.help()
		end, { desc = "Search Help Pages" })
		map("n", "<Leader>sH", function()
			Snacks.picker.highlights()
		end, { desc = "Search Highlights" })
		map("n", "<Leader>sj", function()
			Snacks.picker.jumps()
		end, { desc = "Search Jumps" })
		map("n", "<Leader>sk", function()
			Snacks.picker.keymaps()
		end, { desc = "Search Keymaps" })
		map("n", "<Leader>sm", function()
			Snacks.picker.marks()
		end, { desc = "Search Marks" })
		map("n", "<Leader>sM", function()
			Snacks.picker.man()
		end, { desc = "Search Man Pages" })
		map("n", "<Leader>sp", function()
			Snacks.picker.lazy()
		end, { desc = "Search for Plugin Spec" })
		map("n", "<Leader>sP", function()
			Snacks.picker.projects()
		end, { desc = "Search Projects" })
		map("n", "<Leader>sq", function()
			Snacks.picker.qflist()
		end, { desc = "SearchQuickfix List" })
		map("n", "<Leader>sr", function()
			Snacks.picker.resume()
		end, { desc = "Search Resume" })
		map("n", "<Leader>su", function()
			Snacks.picker.undo()
		end, { desc = "Search Undo History" })

		-- LSP(s)
		map("n", "<Leader>ss", function()
			Snacks.picker.lsp_symbols()
		end, { desc = "Search LSP Symbols" })
		map("n", "<Leader>sS", function()
			Snacks.picker.lsp_workspace_symbols()
		end, { desc = "Search LSP Workspace Symbols" })

		local snacks_group = vim.api.nvim_create_augroup("user.snacks", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			group = snacks_group,
			pattern = { "snacks_picker_input", "snacks_input" },
			callback = function()
				vim.opt_local.autocomplete = false
			end,
		})

		Snacks.setup(snacks_opts)
	end,
}

local mini_icons = {
	"nvim-mini/mini.icons",
	cond = not vim.g.vscode,
	opts = {},
}

local oil = {
	"stevearc/oil.nvim",
	cond = not vim.g.vscode,
	opts = {},
}

return { snacks, oil, mini_icons }
