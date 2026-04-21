local g = vim.g
local opt = vim.opt

-- Global variables
-- leader
g.mapleader = " "
g.maplocalleader = "\\"

-- avoid load builtin plugin
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_gzip = 1
g.loaded_tarPlugin = 1
g.loaded_tar = 1
g.loaded_zipPlugin = 1
g.loaded_zip = 1

g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

-- Options
-- timeout
opt.timeoutlen = 400

-- tab use 4 spaces
-- (auto)indent use 4 spaces
-- backspace use 4 spaces
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4

-- search ignore case
-- but smart case if search pattern contains uppercase letters
opt.smartcase = true
opt.ignorecase = true

if not g.vscode then
	-- auto write
	opt.autowrite = true

	-- vertical split to right
	opt.splitright = true

	-- cmdline completion
	opt.wildmenu = true
	opt.wildmode = "noselect:lastused,full"
	opt.wildoptions = "pum,fuzzy,tagfile"

	-- insert completion
	opt.autocomplete = true
	opt.completeopt = "menu,popup,noselect"
	opt.complete = "o,.,w,b,u,t"

	-- gui
	opt.termguicolors = true
	local cursor_config = {
		"n-v-c:block",
		"i-c-ci-ve:ver25",
		"r-cr:block",
		"o:hor20",
		"a:blinkon0-Cursor",
	}
	opt.guicursor = table.concat(cursor_config, ",")
	opt.background = "light"
end
