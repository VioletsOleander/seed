-- If an action is intended to be either triggered by command and keymap,
-- then define the action here. If an action is intended to be only triggered
-- by keymap (using command will be cumbersome), then define the action in `keymap.lua`.
local com = vim.api.nvim_create_user_command

-- Display help vertically.
com(
  "H",
  "vertical help <args>",
  { nargs = "*", complete = "help", desc = "Show help in vertical split window" }
)

-- Displayed diagnostic makes screen flicker when saving and formatting the file, therefore it
-- should be turned off in the most of the time.
vim.diagnostic.config({
  signs = false,
  underline = false,
  virtual_text = false,
  virtual_lines = false,
})

local show_diagnostic = false
local diagnostic_level_set = false

-- Set diagnostic level.

---@param opts table
local function set_diagnostic_level(opts)
  local level = tonumber(opts.args)
  if level == 1 then
    vim.diagnostic.config({
      signs = true,
      underline = true,
      virtual_text = false,
      virtual_lines = false,
    })
    show_diagnostic = true
  elseif level == 2 then
    vim.diagnostic.config({
      signs = true,
      underline = true,
      virtual_text = true,
      virtual_lines = false,
    })
    show_diagnostic = true
  elseif level == 3 then
    vim.diagnostic.config({
      signs = true,
      underline = true,
      virtual_text = false,
      virtual_lines = true,
    })
    show_diagnostic = true
  else
    vim.notify("Invalid diagnostic level, expecting 1 or 2 or 3")
  end
end

com("SetDiagnosticLevel", set_diagnostic_level, {
  nargs = 1,
  complete = function()
    return { "1", "2", "3" }
  end,
  desc = "Set diagnostic level.",
})

-- Toggle diagnostic display.

local function toggle_diagnostic()
  if show_diagnostic == false then
    -- If user has not set the level explicitly, use default level 2.
    if not diagnostic_level_set then
      vim.diagnostic.config({
        signs = true,
        underline = true,
        virtual_text = true,
        virtual_lines = false,
      })
      diagnostic_level_set = true
    end

    -- Else just recover the last set level.
    vim.diagnostic.show()
    show_diagnostic = true
  else
    vim.diagnostic.hide()
    show_diagnostic = false
  end
end

com(
  "ToggleDiagnostic",
  toggle_diagnostic,
  { desc = "Toggle showing attention attracting diagnostics" }
)

vim.keymap.set(
  "n",
  "<C-a>",
  toggle_diagnostic,
  { desc = "Toggle showing attention attracting diagnostics" }
)

-- Toggle color column.
com("ToggleColorColumn", function()
  if vim.wo.colorcolumn == "" then
    vim.wo.colorcolumn = "+1"
  else
    vim.wo.colorcolumn = ""
  end
end, { desc = "Toggle showing attention attracting colorcolumn" })

-- Toggle lsp inlay hint.
com("ToggleLspInlayHint", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle showing attention attracting lsp inlay hint." })

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

com(
  "ToggleRelativeNumber",
  toggle_relative_number,
  { desc = "Toggle showing attention attracting relativenumber." }
)

vim.keymap.set(
  { "n", "v", "o" },
  "<C-n>",
  toggle_relative_number,
  { desc = "Toggle showing attention attracting relativenumber." }
)

-- Toggle spell check
local function toggle_spell()
  if vim.wo.spell then
    vim.wo.spell = false
    vim.notify("Spell check for current window is off")
  else
    vim.wo.spell = true
    vim.notify("Spell check for current window is on")
  end
end

com("ToggleSpell", toggle_spell, { desc = "Toggle spell check." })
vim.keymap.set("n", "<C-s>", toggle_spell, { desc = "Toggle spell check" })

-- Format current buffer.
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
    require("conform").format({ lsp_format = "fallback", timeout_ms = 3000 })
  end

  vim.cmd("update")
end

com(
  "FormatBuffer",
  format_and_save,
  { desc = "Format current buffer with preconfigured formatter and save it." }
)

vim.keymap.set("n", "<Leader>w", format_and_save, { desc = "Format and save file" })
vim.keymap.set("n", "<Leader><CR>", format_and_save, { desc = "Format and save file" })
