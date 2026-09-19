local map = vim.keymap.set

-- Keymaps shared by VSCode and Neovim

-- Jump to line start/end
map({ "n", "x", "o" }, "H", "^", { desc = "Jump to line start" })
map({ "n", "x", "o" }, "L", "$", { desc = "Jump to line end" })

-- Jump 4 lines up/down
map({ "n", "x", "o" }, "<C-k>", "4k", { desc = "Jump 4 lines up" })
map({ "n", "x", "o" }, "<C-j>", "4j", { desc = "Jump 4 lines down" })

-- Scroll 4 lines up/down
map({ "n", "x", "o" }, "<C-y>", "4<C-y>", { desc = "Jump 4 lines up" })
map({ "n", "x", "o" }, "<C-e>", "4<C-e>", { desc = "Jump 4 lines down" })

-- Copy/paste to system clipboard
map({ "n", "v" }, "<Leader>y", '"+y', { desc = "Yank to system clipboard" })
map({ "n", "v" }, "<Leader>p", '"+p', { desc = "Paste from system clipboard" })

-- Clear screen
map("n", "<Leader>c", function()
  vim.cmd("nohlsearch")
end, { desc = "Clear Screen (including search highlight)" })

map("n", "zz", function()
  vim.cmd("normal! zz")
  vim.cmd("nohlsearch")
end, { desc = "Make cursor line in screen center and clear highlight" })
map("n", "zt", function()
  vim.cmd("normal! zt")
  vim.cmd("nohlsearch")
end, { desc = "Make cursor line in screen top and clear highlight" })
map("n", "zb", function()
  vim.cmd("normal! zb")
  vim.cmd("nohlsearch")
end, { desc = "Make cursor line in screen bottom and clear highlight" })

-- Insert/Visual/Select mode to normal mode
-- Notice that in CTRL-X CTRL-L mode this will not work because vim does not allow this, which is kind of annoying
-- sometimes
map({ "i", "v", "x", "c" }, "<C-l>", "<Esc>", { desc = "Switch to normal mode" })

-- Move between panes
map("n", "<C-h>", "<C-w>h", { desc = "Move to the left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to the right window" })

-- Switch between buffers
map("n", "<BS>", "<C-^>", { desc = "Switch to alternate file" })

-- Close
map("n", "<C-c>", "<Cmd>close<CR>", { desc = "Close current window" })

-- Quit
map("n", "<C-q>", "<Cmd>quit<CR>", { desc = "Quit current window" })
map("n", "<Leader>qq", "<Cmd>qall<CR>", { desc = "Exit Neovim" })

-- Correct spell
map(
  "i",
  "<C-a>",
  "<C-g>u<Esc>[s1z=`]a<C-g>u",
  { desc = "Correc last spell using the first suggestion" }
)

-- Format current line
-- Notice that using 'Esc + a' makes sure the cursor position will be correctly preserved, while
-- using ':normal' does not.
map("i", "<C-q>", "<C-g>u<Esc>gwwa<C-g>u", { desc = "Format current paragraph." })

--- Return the character after cursor
---
---@return string
local function get_next_char()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  return line:sub(col + 1, col + 1)
end

--- Return true if the char after cursor is jumpable
--- Jumpable chars including: ] } " ' ` > ) ,
---
---@return boolean
local function next_is_jumpable()
  local chars = { ")", "]", "}", '"', "'", "`", ">", "," }
  local next_char = get_next_char()

  for _, char in ipairs(chars) do
    if next_char == char then
      return true
    end
  end

  return false
end

-- Tab for accepting completion or jump out of brackets
map("i", "<Tab>", function()
  if vim.fn.pumvisible() ~= 0 then
    return "<C-y>"
  elseif next_is_jumpable() then
    return "<Right>"
  else
    return "<Tab>"
  end
end, { expr = true, desc = "Confirm completion or jump out of brackets" })

-- Tab/S-Tab for iterating completion items
map("c", "<Tab>", function()
  return vim.fn.pumvisible() ~= 0 and "<C-n>" or "<Tab>"
end, { expr = true, desc = "Select next completion item" })
map("c", "<S-Tab>", function()
  return vim.fn.pumvisible() ~= 0 and "<C-p>" or "<S-Tab>"
end, { expr = true, desc = "Select previous completion item" })

-- Ctrl-j/k for selecting completion items
map("i", "<C-j>", function()
  return vim.fn.pumvisible() ~= 0 and "<C-n>" or "<Down>"
end, { expr = true, desc = "Select next completion or move current line down" })
map("i", "<C-k>", function()
  return vim.fn.pumvisible() ~= 0 and "<C-p>" or "<Up>"
end, { expr = true, desc = "Select previous completion or move current line up" })

map("c", "<C-j>", function()
  return vim.fn.pumvisible() ~= 0 and "<C-n>" or "<C-j>"
end, { expr = true, desc = "Select previous completion" })
map("c", "<C-k>", function()
  return vim.fn.pumvisible() ~= 0 and "<C-p>" or "<C-k>"
end, { expr = true, desc = "Select previous completion" })

-- Ctrl-e to hide completion menu or signature help
map("i", "<C-e>", function()
  if vim.fn.pumvisible() ~= 0 then
    vim.api.nvim_feedkeys(vim.keycode("<C-e>"), "n", false)
  end
end, { desc = "Hide completion menu or close lsp float windows" })

-- Exit terminal mode
map("t", [[<C-\><C-\>]], [[<C-\><C-n>]], { desc = "Exit terminal mode" })

--- Jump by user input.
---
---@param input string? User input.
---@param up boolean If true, jump up, otherwise jump down.
local function jump_by_input(input, up)
  -- Press Esc two times makes input == nil.
  if not input then
    return
  end

  local number = tonumber(input)

  if not number then
    vim.notify("The input is invalid, please input valid numbers.")
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(0)

  if up then
    vim.api.nvim_win_set_cursor(0, { math.max(cursor[1] - number, 1), cursor[2] })
  else
    vim.api.nvim_win_set_cursor(
      0,
      { math.min(cursor[1] + number, vim.api.nvim_buf_line_count(0)), cursor[2] }
    )
  end
end

-- Relative jump up/down.
map("n", "gk", function()
  vim.wo.relativenumber = true

  vim.ui.input({ prompt = "Enter number of lines to jump up: ", scope = "cursor" }, function(input)
    jump_by_input(input, true)
    vim.wo.relativenumber = false
  end)
end, { desc = "Prompt user for a relative jump up." })

map("n", "gj", function()
  vim.wo.relativenumber = true

  vim.ui.input(
    { prompt = "Enter number of lines to jump down: ", scope = "cursor" },
    function(input)
      jump_by_input(input, false)
      vim.wo.relativenumber = false
    end
  )
end, { desc = "Prompt user for a relative jump down." })

-- Jump to top/middle/bottom
map("n", "MH", "H", { desc = "Jump to the line on top of current window." })
map("n", "MM", "M", { desc = "Jump to the middle line of current window." })
map("n", "ML", "L", { desc = "Jump to the line in the bottom of current window." })

-- Disable middle mouse paste
map({ "n", "i" }, "<MiddleMouse>", "<Nop>", { desc = "Do nothing." })
