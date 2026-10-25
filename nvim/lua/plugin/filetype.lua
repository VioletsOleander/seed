---@module "lazy"

local conform = { "stevearc/conform.nvim" }
local lspconfig = { "neovim/nvim-lspconfig" }

---@type LazyPluginSpec
local typst_preview = {
  "chomosuke/typst-preview.nvim",
  cmd = "TypstPreview",
}

return { lspconfig, conform, typst_preview }
