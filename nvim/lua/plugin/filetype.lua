---@module "lazy"
---@module "conform"

---@type LazyPluginSpec
local conform = {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      rust = { "rustfmt" },
      python = { "ruff_format", "ruff_organize_imports" },
      toml = { "dprint" },
      markdown = { "dprint" },
      typescript = { "dprint" },
      javascript = { "dprint" },
      yaml = { "dprint" },
      json = { "dprint" },
      jsonc = { "dprint" },
      svelte = { "dprint" },
      nu = { "nufmt" },
      tex = { "tex-fmt" },
      typst = { "typstyle" },
    },
  },
}

---@module "lazy"

---@type LazyPluginSpec
local lsp_config = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    vim.lsp.enable({
      -- Lua
      "lua_ls",
      "stylua",
      -- Python
      "ty",
      "ruff",
      -- Json
      "jsonls",
      -- Yaml
      "yamlls",
      -- Toml
      "taplo",
      -- Rust
      "rust_analyzer",
      -- Typescript, HTML, CSS, Svelte
      "vtsls",
      "html",
      "cssls",
      "svelte",
      "eslint",
      -- Nushell
      "nushell",
      -- Latex
      "texlab",
      -- Typst
      "tinymist",
    })
  end,
}

---@type LazyPluginSpec
local typst_preview = {
  "chomosuke/typst-preview.nvim",
  cmd = "TypstPreview",
}

return { lsp_config, conform, typst_preview }
