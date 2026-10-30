local com = vim.api.nvim_create_user_command
local map = vim.keymap.set

-- Display help vertically.
com(
  "H",
  "vertical help <args>",
  { nargs = "*", complete = "help", desc = "Show help in vertical split window" }
)

-- Diagnostic

com("ToggleDiagnostic", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle showing diagnostics" })

map("n", "<C-a>", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle showing diagnostics" })

---@param args table
local function set_diagnostic_level(args)
  local level = tonumber(args.args)

  if level == 1 then
    vim.diagnostic.config({
      signs = true,
      underline = false,
      virtual_text = false,
      virtual_lines = false,
    })
  elseif level == 2 then
    vim.diagnostic.config({
      signs = true,
      underline = true,
      virtual_text = false,
      virtual_lines = false,
    })
  elseif level == 3 then
    vim.diagnostic.config({
      signs = true,
      underline = true,
      virtual_text = true,
      virtual_lines = false,
    })
  elseif level == 4 then
    vim.diagnostic.config({
      signs = true,
      underline = true,
      virtual_text = false,
      virtual_lines = true,
    })
  else
    vim.notify("Invalid diagnostic level, expecting 1 to 4")
  end
end

com("SetDiagnosticLevel", set_diagnostic_level, {
  nargs = 1,
  complete = function()
    return { "1", "2", "3", "4" }
  end,
  desc = "Set diagnostic level.",
})

-- Disable diagnostic by default to avoid screen flicker when saving and formatting the buffer.
vim.diagnostic.enable(false)
-- Set default level = 3.
vim.diagnostic.config({
  signs = true,
  underline = true,
  virtual_text = true,
  virtual_lines = false,
})

-- Toggle color column.
com("ToggleColorColumn", function()
  if vim.wo.colorcolumn == "" then
    vim.wo.colorcolumn = "+1"
  else
    vim.wo.colorcolumn = ""
  end
end, { desc = "Toggle showing colorcolumn" })

-- Toggle lsp inlay hint.
com("ToggleLspInlayHint", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle showing lsp inlay hint." })

-- Toggle relative number
local function toggle_relative_number()
  if vim.wo.relativenumber then
    vim.wo.relativenumber = false
    vim.wo.number = false
  else
    vim.wo.relativenumber = true
    vim.wo.number = true
  end
end

com("ToggleRelativeNumber", toggle_relative_number, { desc = "Toggle showing relativenumber." })
map({ "n", "v", "o" }, "<C-n>", toggle_relative_number, { desc = "Toggle showing relativenumber." })

-- Toggle spell check
local function toggle_spell()
  if vim.o.spell then
    vim.o.spell = false
    vim.notify("Spell check is off")
  else
    vim.o.spell = true
    vim.notify("Spell check is on")
  end
end

com("ToggleSpell", toggle_spell, { desc = "Toggle spell check." })
map("n", "<C-p>", toggle_spell, { desc = "Toggle spell check" })

-- Format current buffer.
local formatters_by_ft = {
  fish = { "fish_indent" },
  javascript = { "dprint" },
  json = { "dprint" },
  jsonc = { "dprint" },
  lua = { "stylua" },
  markdown = { "dprint" },
  nu = { "nufmt" },
  python = { "ruff_format", "ruff_organize_imports" },
  rust = { "rustfmt" },
  svelte = { "dprint" },
  tex = { "tex-fmt" },
  toml = { "dprint" },
  typescript = { "dprint" },
  typst = { "typstyle" },
  yaml = { "dprint" },
}

local function format_and_save()
  -- Invalid buffer.
  if not vim.api.nvim_buf_is_valid(0) or not vim.bo.buftype == "" then
    return
  end

  -- Not editable buffer.
  if not vim.bo.modifiable or vim.bo.readonly then
    return
  end

  if not vim.g.disable_autoformat then
    local formatters = formatters_by_ft[vim.bo.filetype]

    require("conform").format({
      formatters = formatters,
      lsp_format = "fallback",
      timeout_ms = 3000,
    })
  end

  vim.cmd("update")
end

com("FormatBuffer", format_and_save, { desc = "Format current buffer and save it." })

map("n", "<Leader>w", format_and_save, { desc = "Format and save file" })
map("n", "<Leader><CR>", format_and_save, { desc = "Format and save file" })
map("i", "<C-g>w", format_and_save, { desc = "Format and save file" })
map("i", "<C-g><C-w>", format_and_save, { desc = "Format and save file" })

---@param args table
local function tcd(args)
  local dir = args.args
  vim.cmd("tabnew | tcd " .. dir)
end

com("TCD", tcd, {
  nargs = 1,
  complete = function()
    return { "~/codespace/seed" }
  end,
  desc = "Open a new tab and cd to predefined directory",
})
