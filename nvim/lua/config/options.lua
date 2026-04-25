local opt = vim.opt

-- Wait time of mapped sequence
opt.timeoutlen = 500

-- Enable undo/redo changes even after closing and reopening a file
-- opt.undofile = true

-- Case-insensitive searching unless \C or one or more capital letters in the search term
opt.smartcase = true
opt.ignorecase = true

-- Tab and Shift(>>, <<) use 4 spaces
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4

-- Preview substitutions as we typing
-- if necessary, show previews in a split preview window
opt.inccommand = "split"

-- Above are shared configurations between neovim and vscode
if vim.g.vscode then
	return
end
-- Below are neovim-specific configurations

-- Vertically split to right
opt.splitright = true

-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`), raise a dialog asking if we wish to save the current file(s)
opt.confirm = true

-- Write file on buffer change
opt.autowrite = true

if vim.g.use_bulitin_completion then
	-- Cmdline completion
	opt.wildmenu = true
	opt.wildmode = "noselect:lastused,full"
	opt.wildoptions = "pum,fuzzy,tagfile"

	-- Insert completion
	opt.autocomplete = true
	opt.infercase = true
	opt.completeopt = "menuone,popup,preinsert"

	-- Popup meun height
	opt.pumheight = 12
end

-- Gui color
opt.termguicolors = true
opt.background = "light"

-- Gui cursor
local cursor_config = {
	"n-v-c:block",
	"i-c-ci-ve:ver25",
	"r-cr:block",
	"o:hor20",
	"a:blinkon0-Cursor",
}
opt.guicursor = table.concat(cursor_config, ",")

-- Not display tabline
opt.showtabline = 0

-- Misc
vim.diagnostic.config({ virtual_text = true, severity_sort = true })
