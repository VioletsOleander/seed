local map = vim.keymap.set

--- Motions.

-- Goto line start/end.
map({ "n", "x", "o" }, "H", "^", { desc = "Goto line start." })
map({ "n", "x", "o" }, "L", "$", { desc = "Goto line end." })

-- Scroll 25% screen up/down.
map({ "n", "x", "o" }, "<C-y>", function()
  local height = vim.api.nvim_win_get_height(0)
  local count = math.max(1, math.floor(height * 0.25))
  vim.api.nvim_feedkeys(count .. vim.keycode("<C-y>"), "n", false)
end, { desc = "Scroll 25% screen up." })
map({ "n", "x", "o" }, "<C-e>", function()
  local height = vim.api.nvim_win_get_height(0)
  local count = math.max(1, math.floor(height * 0.25))
  vim.api.nvim_feedkeys(count .. vim.keycode("<C-e>"), "n", false)
end, { desc = "Scroll 25% screen down." })

-- Goto surrouding window.
map("n", "<C-k>", "<C-w>k", { desc = "Goto the window above." })
map("n", "<C-j>", "<C-w>j", { desc = "Goto the window below." })
map("n", "<C-h>", "<C-w>h", { desc = "Goto the left window." })
map("n", "<C-l>", "<C-w>l", { desc = "Goto the right window." })

-- Goto alternate buffer.
map("n", "<BS>", "<C-^>", { desc = "Goto the alternate buffer." })

-- Goto top/middle/bottom line
map("n", "gk", "H", { desc = "Goto the top line." })
map("n", "gm", "M", { desc = "Goto the middle line." })
map("n", "gj", "L", { desc = "Goto the bottom line." })

--- LSP.

-- Lsp gotos.
map("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto declaration" })
map("n", "gy", vim.lsp.buf.type_definition, { desc = "Goto type definition" })
map("n", "gI", vim.lsp.buf.implementation, { desc = "Goto implementation" })
map("n", "<C-w>gd", function()
  vim.cmd.vsplit()
  vim.lsp.buf.definition()
end, { desc = "Goto definition in vsplit" })

-- LSP shows.
map("n", "gr", vim.lsp.buf.references, { nowait = true, desc = "Show references" })
map("n", "ga", vim.diagnostic.open_float, { desc = "Show diagnostics" })

-- LSP actions.
map("n", "<Leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })
map({ "n", "v" }, "<Leader>a", vim.lsp.buf.code_action, { desc = "Code action" })

--- Completion.

-- Accept completion or jump next char.
local jumpable_chars = {
  [")"] = true,
  ["]"] = true,
  ["}"] = true,
  ['"'] = true,
  ["'"] = true,
  ["`"] = true,
  [">"] = true,
  [","] = true,
  [";"] = true,
  ["|"] = true,
  ["$"] = true,
}

map("i", "<Tab>", function()
  if vim.fn.pumvisible() ~= 0 then
    return "<C-y>"
  else
    local cursor_line = vim.api.nvim_get_current_line()
    local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
    local next_char = cursor_line:sub(cursor_col + 1, cursor_col + 1)
    return jumpable_chars[next_char] and "<Right>" or "<Tab>"
  end
end, { expr = true, desc = "Accept completion or jump next char." })

-- Iterate completion items or move up/down.
map("i", "<C-j>", function()
  return vim.fn.pumvisible() ~= 0 and "<C-n>" or "<Down>"
end, { expr = true, desc = "Select next completion or move down one line." })
map("i", "<C-k>", function()
  return vim.fn.pumvisible() ~= 0 and "<C-p>" or "<Up>"
end, { expr = true, desc = "Select previous completion or move up one line." })

-- Iterate completion items.
map("c", "<Tab>", function()
  return vim.fn.pumvisible() ~= 0 and "<C-n>" or "<Tab>"
end, { expr = true, desc = "Select next completion item." })
map("c", "<S-Tab>", function()
  return vim.fn.pumvisible() ~= 0 and "<C-p>" or "<S-Tab>"
end, { expr = true, desc = "Select previous completion item." })
map("c", "<C-j>", function()
  return vim.fn.pumvisible() ~= 0 and "<C-n>" or "<C-j>"
end, { expr = true, desc = "Select previous completion." })
map("c", "<C-k>", function()
  return vim.fn.pumvisible() ~= 0 and "<C-p>" or "<C-k>"
end, { expr = true, desc = "Select previous completion." })

--- Others.

-- Copy/Paste.
map({ "n", "v" }, "<Leader>y", '"+y', { desc = "Copy to system clipboard." })
map({ "n", "v" }, "<Leader>p", '"+p', { desc = "Paste from system clipboard." })

-- Clear highlight.
map("n", "<Leader>c", "<Cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "zz", function()
  vim.cmd("normal! zz")
  vim.cmd("nohlsearch")
end, { desc = "Make cursor line in screen center and clear highlight." })

-- Close/Quit window.
map("n", "<C-c>", "<Cmd>close<CR>", { desc = "Close current window." })
map("n", "<C-q>", "<Cmd>quit<CR>", { desc = "Quit current window." })

-- Always search forward/backward.
map("n", "n", "/<CR>", { silent = true, desc = "Search forward with last searched pattern." })
map("n", "N", "?<CR>", { silent = true, desc = "Search backward with last searched pattern." })

-- Disable middle mouse paste.
map({ "n", "i" }, "<MiddleMouse>", "<Nop>")

-- Open terminal.
map("n", "<C-w>gt", function()
  vim.cmd("vsplit +terminal")
end, { desc = "Open terminal in vertical split." })

-- Insert/Visual/Select mode to normal mode.
-- In CTRL-X CTRL-L mode this will not work because vim does not allow this, which is kind of annoying sometimes.
map({ "i", "v", "x", "c" }, "<C-l>", "<Esc>", { desc = "Switch to normal mode." })

-- Correct spell.
map(
  "i",
  "<C-a>",
  "<C-g>u<Esc>[s1z=`]a<C-g>u",
  { desc = "Correct last spell with the first suggestion." }
)

-- Format line.
-- Using 'Esc + a' makes sure the cursor position will be correctly preserved, while using ':normal' does not.
map("i", "<C-q>", "<C-g>u<Esc>gwwa<C-g>u", { desc = "Format current line." })

-- Indent line.
-- Change it to C-I if the terminal emulator supports CSI u.
map("i", "<C-d>", "<C-f>", { desc = "Indent current line." })

-- Terminal mode to normal mode.
map("t", [[<C-\><C-\>]], [[<C-\><C-n>]], { desc = "Switch from terminal mode to normal mode." })
