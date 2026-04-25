local map = vim.keymap.set

-- Keymaps shared by VSCode and Neovim

-- Jump to line start/end
map({ "n", "x", "o" }, "H", "^", { desc = "Jump to line start" })
map({ "n", "x", "o" }, "L", "$", { desc = "Jump to line end" })

-- Jump to top/bottom of screen
map({ "n", "x", "o" }, "<Leader>H", "H", { desc = "Jump to top of screen" })
map({ "n", "x", "o" }, "<Leader>L", "L", { desc = "Jump to bottom of screen" })

-- Jump 5 lines up/down
map({ "n", "x", "o" }, "<C-j>", "5j", { desc = "Jump 5 lines down" })
map({ "n", "x", "o" }, "<C-k>", "5k", { desc = "Jump 5 lines up" })

-- Copy/paste to system clipboard
map({ "n", "v" }, "<Leader>y", '"+y', { desc = "Yank to system clipboard" })
map({ "n", "v" }, "<Leader>p", '"+p', { desc = "Paste from system clipboard" })

-- Insert newline above/below (the default mapping will not move the cursor)
map("n", "]<Space>", "o<Esc>", { silent = true, desc = "Insert a newline below" })
map("n", "[<Space>", "O<Esc>", { silent = true, desc = "Insert a newline above" })

-- Keymaps for VSCode only
-- VSCode commands references: https://code.visualstudio.com/api/references/commands
if vim.g.vscode then
	local vscode = require("vscode")
	local action = vscode.action

	-- Clear screen
	map("n", "<Leader>c", function()
		vim.cmd("nohlsearch")
		action("closeMarkersNavigation")
	end, { desc = "Clear Search Highlight and Close Markers Navigation" })

	--- Helper function to redraw screen and re-put line
	---
	---@param pos string
	local function reveal_line(pos)
		action("revealLine", {
			args = { { lineNumber = vim.api.nvim_win_get_cursor(0)[1] - 1, at = pos } },
		})
	end

	-- Center/Top/Bottom screen and clear screen
	map("n", "zz", function()
		reveal_line("center")
		vim.cmd("nohlsearch")
	end, { desc = "Center Screen and Clear Search Highlight" })
	map("n", "zt", function()
		reveal_line("top")
		vim.cmd("nohlsearch")
	end, { desc = "Top Screen and Clear Search Highlight" })
	map("n", "zb", function()
		reveal_line("bottom")
		vim.cmd("nohlsearch")
	end, { desc = "Bottom Screen and Clear Search Highlight" })

	--- Helper function to map key to a vscode action
	---
	---@param key string
	---@param action_name string
	---@param desc string
	local function key_to_action(key, action_name, desc)
		map("n", key, function()
			action(action_name)
		end, { desc = desc })
	end

	-- Gotos
	key_to_action("<Leader>ss", "workbench.action.gotoSymbol", "Search symbols in current file")
	key_to_action("gy", "editor.action.goToTypeDefinition", "Go to Type Definition")
	key_to_action("]d", "editor.action.marker.next", "Go to Next Problem/Diagnostic")
	key_to_action("[d", "editor.action.marker.prev", "Go to Previous Problem/Diagnostic")

	-- somehow the nextInFiles/prevInFiles doesn't work well
	-- go to next problem/diagnostic in all files
	-- map('n', ']D', function()
	--     action('editor.action.marker.nextInFiles')
	-- end)
	-- go to previous problem/diagnostic in all files
	-- map('n', '[D', function()
	--     action('editor.action.marker.prevInFiles')
	-- end)

	-- Explore
	key_to_action("<Leader>/", "workbench.action.quickOpen", "Search files")
	key_to_action("<Leader>e", "workbench.view.explorer", "Open and Focus on Explorer")

	-- Code actions
	key_to_action("<Leader>a", "editor.action.quickFix", "Quick Fix")
	key_to_action("<Leader>r", "editor.action.rename", "Rename Symbol")

	-- Save file
	key_to_action("<Leader>w", "workbench.action.files.save", "Save File")
	key_to_action("<Leader><CR>", "workbench.action.files.save", "Save File")

	return
end

-- Keymaps for Neovim only

-- Clear screen
map("n", "<Leader>c", function()
	vim.cmd("nohlsearch")
	Snacks.notifier.hide()
end, { desc = "Clear Screen (including search highlight, notifications)" })

-- Center screen and clear screen
map("n", "zz", function()
	vim.cmd("normal! zz")
	vim.cmd("nohlsearch")
end, { desc = "Center Screen and Clear Search Highlight" })

-- Insert mode to normal mode
map("i", "jj", "<Esc>", { desc = "Insert Mode to Normal Mode" })
map("i", "jk", "<Esc>", { desc = "Insert Mode to Normal Mode" })
map("i", "kk", "<Esc>", { desc = "Insert Mode to Normal Mode" })
map("i", "<M-n>", "<Esc>", { desc = "Insert Mode to Normal Mode" })

-- Quit
map({ "i", "n" }, "<C-q>", "<Cmd>quit<CR>", { desc = "Quit Current Window" })

-- Save
map("n", "<Leader>w", "<Cmd>w<CR>", { desc = "Save File" })
map("n", "<Leader><CR>", "<Cmd>w<CR>", { desc = "Save File" })

-- Completion
map("i", "<C-]>", "<C-X><C-]>", { desc = "Completion with tags" })
map("i", "<C-F>", "<C-X><C-F>", { desc = "Completion with file names" })
map("i", "<C-D>", "<C-X><C-D>", { desc = "Completion with definition or marcros" })
map("i", "<C-L>", "<C-X><C-L>", { desc = "Completion with seen whole lines" })

--- Return the character after cursor
---
---@return string
local function get_next_char()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	return line:sub(col + 1, col + 1)
end

--- Return true if the char after cursor is a closer (i.e. ), ], }, ", ', `, >)
---
---@return boolean
local function next_is_closer()
	local next_char = get_next_char()

	local closers = { ")", "]", "}", '"', "'", "`", ">" }
	for _, closer in ipairs(closers) do
		if next_char == closer then
			return true
		end
	end

	return false
end

if not vim.g.use_bulitin_completion then
	-- Tab for jumping out of brackets
	map("i", "<Tab>", function()
		return next_is_closer() and "<Right>" or "<Tab>"
	end, { expr = true, desc = "Jump out of brackets" })

	return
end

-- Builtin completion specific

--- Return true if the completion menu is visible
---
---@return boolean
local function pum_is_visible()
	return vim.fn.pumvisible() ~= 0
end

-- Tab for accepting completion or jump out of brackets
map("i", "<Tab>", function()
	if pum_is_visible() then
		return "<C-y>"
	elseif next_is_closer() then
		return "<Right>"
	else
		return "<Tab>"
	end
end, { expr = true, desc = "Confirm completion or jump out of brackets" })

-- Tab/S-Tab for iterating completion items
map("c", "<Tab>", function()
	return pum_is_visible() and "<C-n>" or "<Tab>"
end, { expr = true, desc = "Select next completion item" })
map("c", "<S-Tab>", function()
	return pum_is_visible() and "<C-p>" or "<S-Tab>"
end, { expr = true, desc = "Select previous completion item" })

-- Ctrl-j/k for selecting completion items
map({ "i", "c" }, "<C-j>", function()
	if pum_is_visible() then
		return "<C-n>"
	else
		return "<C-j>"
	end
end, { expr = true, desc = "Select next completion" })

map({ "i", "c" }, "<C-k>", function()
	if pum_is_visible() then
		return "<C-p>"
	else
		return "<C-k>"
	end
end, { expr = true, desc = "Select previous completion" })
