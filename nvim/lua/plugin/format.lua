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

return { conform }
