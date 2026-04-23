local map = vim.keymap.set
local cmd = vim.cmd

-- Keymaps for both vscode and Neovim
-- jump to line start/end
map({ "n", "x", "o" }, "H", "^", { desc = "Jump to line start" })
map({ "n", "x", "o" }, "L", "$", { desc = "Jump to line end" })

-- jump to top/bottom of screen
map({ "n", "x", "o" }, "<Leader>H", "H", { desc = "Jump to top of screen" })
map({ "n", "x", "o" }, "<Leader>L", "L", { desc = "Jump to bottom of screen" })

-- jump 5 lines up/down
map({ "n", "x", "o" }, "<C-j>", "5j", { desc = "Jump 5 lines down" })
map({ "n", "x", "o" }, "<C-k>", "5k", { desc = "Jump 5 lines up" })

-- copy/paste to system clipboard
map({ "n", "v" }, "<Leader>y", '"+y', { desc = "Yank to system clipboard" })
map({ "n", "v" }, "<Leader>p", '"+p', { desc = "Paste from system clipboard" })

if vim.g.vscode then
	-- Keymaps for vscode
	-- vscode commands references: https://code.visualstudio.com/api/references/commands
	local vscode = require("vscode")
	local action = vscode.action

	-- clear search highlight, close marker widget
	map("n", "<Leader>c", function()
		cmd.nohlsearch()
		action("closeMarkersNavigation")
	end, { desc = "Clear Search Highlight and Close Markers Navigation" })

	-- center screen and clear search highlight
	local function reveal_line(pos)
		action("revealLine", {
			args = { { lineNumber = vim.api.nvim_win_get_cursor(0)[1] - 1, at = pos } },
		})
	end
	map("n", "zz", function()
		reveal_line("center")
		cmd.nohlsearch()
	end, { desc = "Center Screen and Clear Search Highlight" })
	map("n", "zt", function()
		reveal_line("top")
		cmd.nohlsearch()
	end, { desc = "Top Screen and Clear Search Highlight" })
	map("n", "zb", function()
		reveal_line("bottom")
		cmd.nohlsearch()
	end, { desc = "Bottom Screen and Clear Search Highlight" })

	--- Helper function to map key to a vscode action
	---@param key string
	---@param action_name string
	---@param desc string
	local function key_to_action(key, action_name, desc)
		map("n", key, function()
			action(action_name)
		end, { desc = desc })
	end

	key_to_action("<Leader>ss", "workbench.action.gotoSymbol", "Search symbols in current file")

	key_to_action("<Leader>/", "workbench.action.quickOpen", "Search files")

	key_to_action("<Leader>e", "workbench.view.explorer", "Open and Focus on Explorer")

	-- go to type definition
	key_to_action("gy", "editor.action.goToTypeDefinition", "Go to Type Definition")

	-- go to previous problem/diagnostic
	key_to_action("]d", "editor.action.marker.next", "Go to Next Problem")
	-- go to next problem/diagnostic
	key_to_action("[d", "editor.action.marker.prev", "Go to Previous Problem")
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
	key_to_action("<Leader>a", "editor.action.quickFix", "Quick Fix")

	-- rename symbol
	key_to_action("<Leader>r", "editor.action.rename", "Rename Symbol")

	-- save
	key_to_action("<Leader>w", "workbench.action.files.save", "Save File")
	key_to_action("<Leader><CR>", "workbench.action.files.save", "Save File")
else
	-- Keymaps for Neovim
	-- clear search highlight
	map("n", "<Leader>c", function()
		cmd.nohlsearch()
		Snacks.notifier.hide()
	end, { desc = "Clear Screen (including search highlight, notifications)" })

	-- center screen and clear search highlight
	map("n", "zz", function()
		cmd.normal({ args = { "zz" }, bang = true })
		cmd.nohlsearch()
	end, { desc = "Center Screen and Clear Search Highlight" })

	-- insert mode to normal mode
	map("i", "jj", "<Esc>", { desc = "Insert Mode to Normal Mode" })
	map("i", "jk", "<Esc>", { desc = "Insert Mode to Normal Mode" })
	map("i", "kk", "<Esc>", { desc = "Insert Mode to Normal Mode" })
	map("i", "<M-n>", "<Esc>", { desc = "Insert Mode to Normal Mode" })

	-- completion
	map("i", "<C-]>", "<C-X><C-]>", { desc = "Completion with tags" })
	map("i", "<C-F>", "<C-X><C-F>", { desc = "Completion with file names" })
	map("i", "<C-D>", "<C-X><C-D>", { desc = "Completion with definition or marcros" })
	map("i", "<C-L>", "<C-X><C-L>", { desc = "Completion with seen whole lines" })

	-- quit
	map({ "i", "n" }, "<C-q>", "<Cmd>quit<CR>", { desc = "Quit Current Window" })

	-- save
	map("n", "<Leader>w", "<Cmd>w<CR>", { desc = "Save File" })
	map("n", "<Leader><CR>", "<Cmd>w<CR>", { desc = "Save File" })

	local function is_closer()
		local line = vim.api.nvim_get_current_line()
		local col = vim.api.nvim_win_get_cursor(0)[2]
		local char_after = line:sub(col + 1, col + 1)
		local closers = { ")", "]", "}", '"', "'", "`", ">" }

		for _, closer in ipairs(closers) do
			if char_after == closer then
				return true
			end
		end

		return false
	end

	-- tab for completion or jump out
	map("i", "<Tab>", function()
		if vim.fn.pumvisible() ~= 0 then
			return "<C-n>"
		elseif is_closer() then
			return "<Right>"
		else
			return "<Tab>"
		end
	end, { expr = true, silent = true, desc = "Jump out of brackets or select next completion" })
	map("i", "<S-Tab>", function()
		return vim.fn.pumvisible() ~= 0 and "<C-p>" or "<S-Tab>"
	end, { expr = true, silent = true, desc = "Select previous completion" })

	-- autopairs
	local the_pairs = {
		["("] = "()",
		["["] = "[]",
		["{"] = "{}",
		["'"] = "''",
		['"'] = '""',
	}

	for open, close in pairs(the_pairs) do
		map("i", open, function()
			local col = vim.api.nvim_win_get_cursor(0)[2]
			local line = vim.api.nvim_get_current_line()
			local char_after = line:sub(col + 1, col + 1)

			if char_after:match("%w") then
				return open
			else
				return close .. "<Left>"
			end
		end, { expr = true })
	end

	map("i", "<CR>", function()
		if vim.fn.pumvisible() ~= 0 then
			-- accept completion if menu is visible
			return "<C-y>"
		else
			-- autopairs if menu is not visible
			local col = vim.api.nvim_win_get_cursor(0)[2]
			local line = vim.api.nvim_get_current_line()
			local before = line:sub(col, col)
			local after = line:sub(col + 1, col + 1)

			if (before == "{" and after == "}") or (before == "(" and after == ")") then
				return " <CR><Up><End><CR>"
			end

			-- otherwise just insert a newline
			return "<CR>"
		end
	end, { expr = true })

	-- Lsp keymaps
	map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })

	map("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
	map("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

	map("n", "<Leader>r", vim.lsp.buf.rename, { desc = "Rename Symbol" })
	map({ "n", "v" }, "<Leader>a", vim.lsp.buf.code_action, { desc = "Code Action" })

	map("n", "<Leader>cd", vim.diagnostic.open_float, { desc = "Show Line Diagnostics" })
	map("n", "[d", function()
		vim.diagnostic.jump({ count = 1, float = true })
	end, { desc = "Prev Diagnostic" })
	map("n", "]d", function()
		vim.diagnostic.jump({ count = -1, float = true })
	end, { desc = "Next Diagnostic" })
end
