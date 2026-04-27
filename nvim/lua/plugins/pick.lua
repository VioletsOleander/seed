---@module "snacks"

---@type snacks.Config
local snacks_opts = {
	-- File load
	bigfile = { enabled = true },
	quickfile = { enabled = true },
	-- UI
	input = { enabled = true },
	indent = { enabled = true },
	notifier = { enabled = true, timeout = 3000 },
	bufdelete = { enabled = true },
	-- Picker
	explorer = { enabled = true, replace_netrw = true, trash = true },
	picker = {
		enabled = true,
		win = {
			input = {
				keys = {
					["jk"] = { "confirm", mode = { "i", "n" } },
					["<Esc>"] = { "close", mode = { "i", "n" } },
					["<C-q>"] = { "close", mode = { "i", "n" } },
					["<C-j>"] = { "list_down", mode = { "i", "n" } },
					["<C-k>"] = { "list_up", mode = { "i", "n" } },
					["<Leader>v"] = { "edit_vsplit", mode = { "i", "n" } },
					["<Leader>s"] = { "edit_split", mode = { "i", "n" } },
				},
			},
			list = {
				keys = {
					["jk"] = { "confirm", mode = { "i", "n" } },
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

local function set_snacks_keymap()
	local map = vim.keymap.set

	map("n", "<Leader>e", function()
		Snacks.explorer()
	end, { desc = "Toggle file explorer" })
	map("n", "<Leader>R", function()
		Snacks.rename.rename_file()
	end, { desc = "Rename file" })
	map("n", "<Leader>:", function()
		Snacks.picker.command_history()
	end, { desc = "Show command history" })
	map("n", "<Leader>n", function()
		Snacks.picker.notifications()
	end, { desc = "Show notification history" })

	-- Buffer (b)
	map("n", "<Leader>;", function()
		Snacks.picker.buffers()
	end, { desc = "Find buffers" })
	map("n", "<Leader>j", function()
		Snacks.picker.buffers()
	end, { desc = "Find buffers" })
	map("n", "<Leader>bd", function()
		Snacks.bufdelete()
	end, { desc = "Delete buffer without close its pane" })

	-- File (f)
	map("n", "<Leader><Leader>", function()
		Snacks.picker.smart()
	end, { desc = "Smart find files" })
	map("n", "<Leader>ff", function()
		Snacks.picker.files()
	end, { desc = "Find files" })
	map("n", "<Leader>fc", function()
		Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
	end, { desc = "Find config file" })
	map("n", "<Leader>fr", function()
		Snacks.picker.recent()
	end, { desc = "Find recent files" })

	-- Grep (g)
	map("n", "<Leader>g", function()
		Snacks.picker.grep()
	end, { desc = "Grep search" })
	map("n", "<Leader>gb", function()
		Snacks.picker.grep_buffers()
	end, { desc = "Grep search opened buffers" })
	map({ "n", "x" }, "<Leader>gw", function()
		Snacks.picker.grep_word()
	end, { desc = "Grep search visual selection or word" })
	map("n", "<Leader>gh", function()
		local help_dirs = vim.api.nvim_get_runtime_file("doc/*.txt", true)
		Snacks.picker.grep({ dirs = help_dirs, live = true })
	end, { desc = "Grep search help" })

	-- Git (g)
	map("n", "<Leader>gl", function()
		Snacks.picker.git_log()
	end, { desc = "Show git log" })
	map("n", "<Leader>lg", function()
		Snacks.lazygit()
	end, { desc = "Toggle lazygit" })

	-- Search (s)
	map("n", '<Leader>sg"', function()
		Snacks.picker.registers()
	end, { desc = "Search registers" })
	map("n", "<Leader>s/", function()
		Snacks.picker.search_history()
	end, { desc = "Search 'search' history" })
	map("n", "<Leader>sa", function()
		Snacks.picker.autocmds()
	end, { desc = "Search autocmds" })
	map("n", "<Leader>sb", function()
		Snacks.picker.lines()
	end, { desc = "Search buffer lines" })
	map("n", "<Leader>sc", function()
		Snacks.picker.commands()
	end, { desc = "Search commands" })
	map("n", "<Leader>sD", function()
		Snacks.picker.diagnostics()
	end, { desc = "Search diagnostics" })
	map("n", "<Leader>sd", function()
		Snacks.picker.diagnostics_buffer()
	end, { desc = "Search buffer diagnostics" })
	map("n", "<Leader>sh", function()
		Snacks.picker.help()
	end, { desc = "Search help pages" })
	map("n", "<Leader>sH", function()
		Snacks.picker.highlights()
	end, { desc = "Search highlights" })
	map("n", "<Leader>sj", function()
		Snacks.picker.jumps()
	end, { desc = "Search jumps" })
	map("n", "<Leader>sk", function()
		Snacks.picker.keymaps()
	end, { desc = "Search keymaps" })
	map("n", "<Leader>sm", function()
		Snacks.picker.marks()
	end, { desc = "Search marks" })
	map("n", "<Leader>sM", function()
		Snacks.picker.man()
	end, { desc = "Search man pages" })
	map("n", "<Leader>sp", function()
		Snacks.picker.projects()
	end, { desc = "Search projects" })
	map("n", "<Leader>sq", function()
		Snacks.picker.qflist()
	end, { desc = "Search quickfix list" })
	map("n", "<Leader>sr", function()
		Snacks.picker.resume()
	end, { desc = "Resume last search" })
	map("n", "<Leader>su", function()
		Snacks.picker.undo()
	end, { desc = "Search undo history" })

	-- LSP (s)
	map("n", "<Leader>ss", function()
		Snacks.picker.lsp_symbols()
	end, { desc = "Search lsp symbols" })
	map("n", "<Leader>sS", function()
		Snacks.picker.lsp_workspace_symbols()
	end, { desc = "Search lsp workspace symbols" })
end

local function set_snacks_autocmd()
	local snacks_group = vim.api.nvim_create_augroup("user.snacks", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = snacks_group,
		pattern = { "snacks_picker_input", "snacks_input" },
		callback = function()
			vim.opt_local.autocomplete = false
		end,
	})
end

local snacks = {
	"folke/snacks.nvim",
	cond = not vim.g.vscode,
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.snacks_animate = false

		set_snacks_keymap()
		set_snacks_autocmd()

		Snacks.setup(snacks_opts)
	end,
}

local oil = {
	"stevearc/oil.nvim",
	cond = not vim.g.vscode,
	opts = {
		view_options = {
			show_hidden = true,
		},
	},
}

return { snacks, oil }
