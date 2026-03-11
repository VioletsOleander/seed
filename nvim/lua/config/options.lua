local g = vim.g
local opt = vim.opt

-- Global variables
g.mapleader = " "
g.maplocalleader = "\\"

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

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
    -- n-v: Normal, Visual use block
    -- i-c-ci-ve: Insert, Command-line Normal/Insert, Visual-exclude mode use ver25 (vertical bar)
    -- r-cr: Replace, Command-line Replace mode use block
    -- o: Operator-pending mode use hor20 (horizontal bar)
    -- blinkon0: Disable blinking
    opt.guicursor = {
        "n-v:block-blinkon0",
        "i-c-ci-ve:ver25-blinkon0",
        "r-cr:block-blinkon0",
        "o:hor20-blinkon0",
    }
end
