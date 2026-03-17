local g = vim.g
local opt = vim.opt

-- Global variables
g.mapleader = " "
g.maplocalleader = "\\"

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

-- Options
-- timeout
opt.timeoutlen = 300

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
end
