local map = vim.keymap.set
local cmd = vim.cmd

-- Keymaps for both vscode and Neovim
-- jump to line start/end
map({ "n", "x", "o" }, "<Leader>h", "^")
map({ "n", "x", "o" }, "<Leader>l", "$")

-- copy/paste to system clipboard
map({ "n", "v" }, "<Leader>y", '"+y')
map({ "n", "v" }, "<Leader>p", '"+p')

if vim.g.vscode then
	-- Keymaps for vscode
	-- vscode commands references: https://code.visualstudio.com/api/references/commands
	local vscode = require("vscode")
	local action = vscode.action

	-- clear search highlight, close marker widget
	map("n", "<Leader>c", function()
		cmd.nohlsearch()
		action("closeMarkersNavigation")
	end)

	-- center screen and clear search highlight
	local function reveal_line(pos)
		action("revealLine", {
			args = { { lineNumber = vim.api.nvim_win_get_cursor(0)[1] - 1, at = pos } },
		})
	end
	map("n", "zz", function()
		reveal_line("center")
		cmd.nohlsearch()
	end)
	map("n", "zt", function()
		reveal_line("top")
		cmd.nohlsearch()
	end)
	map("n", "zb", function()
		reveal_line("bottom")
		cmd.nohlsearch()
	end)

	--- Helper function to map key to a vscode action
	---@param key string
	---@param action_name string
	local function key_to_action(key, action_name)
		map("n", key, function()
			action(action_name)
		end)
	end

	-- go to type definition
	key_to_action("gy", "editor.action.goToTypeDefinition")

	-- go to previous problem/diagnostic
	key_to_action("]d", "editor.action.marker.next")
	-- go to next problem/diagnostic
	key_to_action("[d", "editor.action.marker.prev")
	-- somehow the nextInFiles/prevInFiles doesn't work well
	-- go to next problem/diagnostic in all files
	-- map('n', ']D', function()
	--     action('editor.action.marker.nextInFiles')
	-- end)
	-- go to previous problem/diagnostic in all files
	-- map('n', '[D', function()
	--     action('editor.action.marker.prevInFiles')
	-- end)
	-- code action
	key_to_action("<Leader>a", "editor.action.quickFix")

	-- rename symbol
	key_to_action("<Leader>r", "editor.action.rename")

	-- save
	key_to_action("<Leader>w", "workbench.action.files.save")
	key_to_action("<Leader><CR>", "workbench.action.files.save")
else
	-- Keymaps for Neovim
	-- clear search highlight
	map("n", "<Leader>c", function()
		cmd.nohlsearch()
	end)

	-- center screen and clear search highlight
	map("n", "zz", function()
		cmd.normal({ args = { "zz" }, bang = true })
		cmd.nohlsearch()
	end)

	-- insert mode to normal mode
	map("i", "jj", "<Esc>")
	map("i", "jk", "<Esc>")
	map("i", "kk", "<Esc>")
	map("i", "<M-n>", "<Esc>")

	-- save
	map("n", "<Leader>w", "<Cmd>w<CR>")
	map("n", "<Leader><CR>", "<Cmd>w<CR>")
end
