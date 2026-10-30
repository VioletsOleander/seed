local au = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("user", { clear = true })

au("BufRead", {
  group = group,
  pattern = { "*/.rustup/*", "*/.cargo/*", "*/.venv/*", "*/node_modules/*", "*/.lua_modules/*" },
  callback = function()
    vim.bo.readonly = true
    vim.bo.modifiable = false
  end,
  desc = "Mark readonly buffer",
})

-- This is more versatile than opt.autowrite.
au({ "BufLeave", "FocusLost" }, {
  group = group,
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
  group = group,
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

au("FileType", {
  group = group,
  pattern = "*",
  callback = function()
    -- No autowarp text and comment.
    -- No autoinsert comment leader after hitting enter and o.
    vim.opt.formatoptions:remove({ "t", "c", "r", "o" })
  end,
  desc = "Set buffer formatoptions",
})
