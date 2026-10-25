--- Define globals.

local g = vim.g

-- Leader key.
g.mapleader = " "
g.maplocalleader = [[\]]

-- Avoid loading some builtin plugins.
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_gzip = 1
g.loaded_tarPlugin = 1
g.loaded_zipPlugin = 1
g.loaded_tutor_mode_plugin = 1

g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

-- Auto format.
g.disable_autoformat = false

-- WSL clipboard.
-- Reference: https://vi.stackexchange.com/questions/42305/neovim-following-the-instructions-in-h-clipboard-wsl-not-work-it-shows-no.
if vim.fn.has("wsl") then
  g.clipboard = {
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

--- Enable language servers.

vim.lsp.enable({
  -- lua
  "lua_ls",
  -- python
  "ty",
  "ruff",
  -- json
  "jsonls",
  -- yaml
  "yamlls",
  -- toml
  "taplo",
  -- rust
  "rust_analyzer",
  -- typescript, html, css, svelte
  "vtsls",
  "html",
  "cssls",
  "svelte",
  "eslint",
  -- nushell
  "nushell",
  -- latex
  "texlab",
  -- typst
  "tinymist",
})

--- Load modules.

vim.loader.enable(true)

require("config.option")
require("config.lazy")

require("config.keymap")
require("config.autocmd")
require("config.usercmd")

vim.cmd("packadd nvim.undotree")

-- Experimental features
-- UI2 (flicker in wildtrigger, disable now)
-- require("vim._core.ui2").enable({ enable = true })
-- vim.opt.cmdheight = 0
