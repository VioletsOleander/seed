local o = vim.o

-- Case-insensitive searching unless \C or one or more capital letters in the search term
o.smartcase = true
o.ignorecase = true

-- Tab and Shift(>>, <<) use 4 spaces
o.expandtab = true
o.tabstop = 4
o.shiftwidth = 0

-- Insert indent after a line ending with { and before a line starting with }
o.smartindent = true

-- Preview substitutions as we typing
-- if necessary, show previews in a split preview window
o.inccommand = "split"

-- Wait time of mapped sequence
o.timeoutlen = 500

-- Vertically split to right
o.splitright = true

-- Do not automatically wrap, in order to avoid weird look of colorcolumn in splitview
o.wrap = false

-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`), raise a dialog asking if we wish to save the current file(s)
o.confirm = true

-- Insert manualcomplete
o.autocomplete = false
o.completeopt = "menuone,popup,noinsert"

-- Cmdline completion (Cmdline completion of blink.cmp is weird, so use default method)
o.wildmenu = true
o.wildmode = "noselect:lastused,full"
o.wildoptions = "pum,fuzzy,tagfile"

-- Popup meun height
o.pumheight = 12

-- Gui color
o.termguicolors = true
o.background = "light"

-- Gui cursor
local cursor_config = {
  "n-v-c:block",
  "i-c-ci-ve:ver25",
  "r-cr:block",
  "o:hor20",
  "a:blinkon0-Cursor",
}
o.guicursor = table.concat(cursor_config, ",")

-- Gui font: FiraCode Retina
o.guifont = "FiraCode Nerd Font Mono:h11:w57"

-- Float window border and popup menu border
o.winborder = "rounded"
o.pumborder = "rounded"

-- Not display tabline
o.showtabline = 0

-- Shell
-- Reference: https://github.com/nushell/integrations/blob/main/nvim/init.lua
o.shell = "nu"

o.shellredir = "out+err> %s"
o.shellcmdflag = "--stdin --no-newline -c"

o.shellxescape = ""
o.shellxquote = ""
o.shellquote = ""

o.shellpipe =
  "| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record"

-- Spell
o.spelllang = "en,cjk"
o.spellfile = vim.fs.joinpath(vim.fn.stdpath("config"), "spell", "en.utf-8.add")

-- Always use LF
o.fileformat = "unix"

-- No swapfile
o.swapfile = false
