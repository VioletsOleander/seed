local au = vim.api.nvim_create_autocmd
local aug = vim.api.nvim_create_augroup

-- Hold autocmds related with buffer/lsp/other(unclassified)
local buf_group = aug("user.buf", { clear = true })
local other_group = aug("user.other", { clear = true })

au("BufRead", {
  group = buf_group,
  pattern = { "*/.rustup/*", "*/.cargo/*", "*/.venv/*", "*/node_modules/*", "*/.lua_modules/*" },
  callback = function()
    vim.bo.readonly = true
    vim.bo.modifiable = false
  end,
  desc = "Mark readonly buffer",
})

-- This is more versatile than opt.autowrite.
au({ "BufLeave", "FocusLost" }, {
  group = buf_group,
  callback = function()
    -- Invalid buffer, non-normal buffer, or unnamed buffer.
    if
      not vim.api.nvim_buf_is_valid(0)
      or vim.bo.buftype ~= ""
      or vim.api.nvim_buf_get_name(0) == ""
    then
      return
    end

    -- Not editable buffer.
    if not vim.bo.modifiable or vim.bo.readonly then
      return
    end

    vim.cmd("silent update")
  end,
  desc = "Autosave buffer",
})

au("FileType", {
  group = buf_group,
  pattern = {
    "javascript",
    "json",
    "jsonc",
    "lua",
    "svelte",
    "typescript",
    "yaml",
  },
  callback = function()
    vim.bo.tabstop = 2
  end,
  desc = "Set two tabstop buffer",
})

-- Cmdline autocompletion (blink's cmdline completion does not support :s/old/new)
-- (but the builin completion feels more laggy compared to blink when complete :!, :checkhealth)
au("CmdlineChanged", {
  group = other_group,
  pattern = { ":", "/", "?" },
  callback = function()
    local cmd = vim.fn.getcmdline()

    -- Avoid stuck on completing binary executables
    if vim.startswith(cmd, "!") then
      return
    end

    vim.fn.wildtrigger()
  end,
  desc = "Show popup menu for completion",
})
