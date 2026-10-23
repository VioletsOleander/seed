-- Experimental features
-- UI2 (flicker in wildtrigger, disable now)
-- require("vim._core.ui2").enable({ enable = true })
-- vim.opt.cmdheight = 0

-- WSL
-- Refers to: https://vi.stackexchange.com/questions/42305/neovim-following-the-instructions-in-h-clipboard-wsl-not-work-it-shows-no
if vim.fn.has("wsl") then
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = true,
  }
end

-- Undotree
vim.cmd("packadd nvim.undotree")
