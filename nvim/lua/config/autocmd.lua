local au = vim.api.nvim_create_autocmd
local aug = vim.api.nvim_create_augroup

-- Hold autocmds related with buffer/lsp/other(unclassified)
local buf_group = aug("user.buf", { clear = true })
local lsp_group = aug("user.lsp", { clear = true })
local other_group = aug("user.other", { clear = true })

-- Readonly files
au("BufRead", {
  group = buf_group,
  pattern = { "*/.rustup/*", "*/.cargo/*", "*/.venv/*", "*/node_modules/*", "*/.lua_modules/*" },
  callback = function()
    vim.bo.readonly = true
    vim.bo.modifiable = false
  end,
})

-- Autosave, more versatile than opt.autowrite
au({ "BufLeave", "FocusLost" }, {
  group = buf_group,
  callback = function()
    -- Invalid buffer, non-normal buffer, or unnamed buffer.
    if
      not vim.api.nvim_buf_is_valid(0)
      or vim.bo.buftype ~= ""
      or vim.api.nvim_buf_get_name() == ""
    then
      return
    end

    -- Not editable buffer.
    if not vim.bo.modifiable or vim.bo.readonly then
      return
    end

    vim.cmd("silent update")
  end,
})

-- Lsp keymaps
au("LspAttach", {
  group = lsp_group,
  pattern = "*",
  callback = function(ev)
    local map = vim.keymap.set

    -- Lsp gotos
    map("n", "gd", vim.lsp.buf.definition, { buf = ev.buf, desc = "Goto definition" })
    map("n", "gD", vim.lsp.buf.declaration, { buf = ev.buf, desc = "Goto declaration" })
    map("n", "gy", vim.lsp.buf.type_definition, { buf = ev.buf, desc = "Goto type definition" })
    map("n", "gI", vim.lsp.buf.implementation, { buf = ev.buf, desc = "Goto implementation" })

    -- LSP shows
    map(
      "n",
      "gr",
      vim.lsp.buf.references,
      { buf = ev.buf, nowait = true, desc = "Show references" }
    )
    map("n", "ga", vim.diagnostic.open_float, { buf = ev.buf, desc = "Show diagnostics" })
    map("n", "gA", function()
      vim.diagnostic.open_float({ close_events = { "BufHidden" } })
    end, { buf = ev.buf, desc = "Show persist diagnostic (requires manual close)" })

    -- LSP actions
    map("n", "<Leader>r", vim.lsp.buf.rename, { buf = ev.buf, desc = "Rename symbol" })
    map("n", "<Leader>a", vim.lsp.buf.code_action, { buf = ev.buf, desc = "Code action" })
  end,
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
  desc = "Automatically show popup menu when typing in cmd line",
})
