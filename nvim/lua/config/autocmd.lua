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
    vim.opt_local.readonly = true
    vim.opt_local.modifiable = false
  end,
})

-- Autosave, more versatile than opt.autowrite
au({ "BufLeave", "FocusLost" }, {
  group = buf_group,
  callback = function()
    -- Invalid buffer.
    if not vim.api.nvim_buf_is_valid(0) or vim.bo.buftype ~= "" then
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
    -- Lsp gotos
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buf = ev.buf, desc = "Go to definition" })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buf = ev.buf, desc = "Go to declaration" })
    vim.keymap.set(
      "n",
      "gy",
      vim.lsp.buf.type_definition,
      { buf = ev.buf, desc = "Go to type definition" }
    )
    vim.keymap.set(
      "n",
      "gI",
      vim.lsp.buf.implementation,
      { buf = ev.buf, desc = "Go to implementation" }
    )

    -- LSP shows
    vim.keymap.set(
      "n",
      "gr",
      vim.lsp.buf.references,
      { buf = ev.buf, nowait = true, desc = "Show references" }
    )
    vim.keymap.set(
      "n",
      "ga",
      vim.diagnostic.open_float,
      { buf = ev.buf, desc = "Show diagnostics" }
    )
    vim.keymap.set("n", "gA", function()
      vim.diagnostic.open_float({ close_events = { "BufHidden" } })
    end, { buf = ev.buf, desc = "Show persist diagnostic (requires manual close)" })

    -- LSP actions
    vim.keymap.set("n", "<Leader>r", vim.lsp.buf.rename, { buf = ev.buf, desc = "Rename symbol" })
    vim.keymap.set(
      "n",
      "<Leader>a",
      vim.lsp.buf.code_action,
      { buf = ev.buf, desc = "Code action" }
    )
  end,
})

-- Cmdline autocompletion (blink's cmdline completion does not support :s/old/new)
-- (but the builin completion feels more laggy comapred to blink when complete :!, :checkhealth)
au("CmdlineChanged", {
  group = other_group,
  pattern = { ":", "/", "?" },
  callback = function()
    local cmd = vim.fn.getcmdline()

    -- Avoid stuck on completing binary executables
    if vim.startswith(cmd, "!") then
      return
    else
      vim.fn.wildtrigger()
    end
  end,
  desc = "Automatically show popup menu when typing in cmd line",
})
