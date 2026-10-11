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

return { lsp_config }
