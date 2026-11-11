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

    -- No autowarp text and comment.
    -- No autoinsert comment leader after hitting enter and o.
    vim.opt.formatoptions:remove({ "t", "c", "r", "o" })

    -- Textwidth 100
    vim.bo.textwidth = 100
  end,
  desc = "Set buffer formatoptions and textwidth",
})

au("FileType", {
  group = group,
  pattern = require("util").treesitter_languages,
  callback = function(ev)
    local buf = ev.buf

    vim.treesitter.start(buf)

    local motions = {
      { query = "@function.outer", name = "function", lower = "f", upper = "F" },
      { query = "@class.outer", name = "class", lower = "c", upper = "C" },
      { query = "@class.outer", name = "class", lower = "]", upper = "[" },
      { query = "@parameter.outer", name = "parameter", lower = "a", upper = "A" }, -- a for argument
      { query = "@call.outer", name = "call", lower = "v", upper = "V" }, -- i for invocation
    }
    local map = vim.keymap.set

    for _, motion in ipairs(motions) do
      -- ]lower to next start
      map({ "n", "x", "o" }, "]" .. motion.lower, function()
        require("nvim-treesitter-textobjects.move").goto_next_start(motion.query, "textobjects")
      end, { buf = buf, desc = "Go to next " .. motion.name .. " start" })

      -- [lower to previous start
      map({ "n", "x", "o" }, "[" .. motion.lower, function()
        require("nvim-treesitter-textobjects.move").goto_previous_start(motion.query, "textobjects")
      end, { buf = buf, desc = "Go to previous " .. motion.name .. " start" })

      -- ]upper to next end
      map({ "n", "x", "o" }, "]" .. motion.upper, function()
        require("nvim-treesitter-textobjects.move").goto_next_end(motion.query, "textobjects")
      end, { buf = buf, desc = "Go to next " .. motion.name .. " end" })

      -- [upper to previous end
      map({ "n", "x", "o" }, "[" .. motion.upper, function()
        require("nvim-treesitter-textobjects.move").goto_previous_end(motion.query, "textobjects")
      end, { buf = buf, desc = "Go to previous " .. motion.name .. " end" })
    end

    map({ "n" }, "<Leader>ml", function()
      require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
    end, { buf = buf, desc = "Swap next parameter" })
    map({ "n" }, "<Leader>mh", function()
      require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
    end, { buf = buf, desc = "Swap previous parameter" })
  end,
})

au("PackChanged", {
  group = vim.api.nvim_create_augroup("user", { clear = false }),
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    if name == "nvim-treesitter" then
      if kind == "update" then
        if not ev.data.active then
          vim.cmd("packadd nvim-treesitter")
        end

        vim.cmd("TSUpdate")
      end
    elseif name == "blink.cmp" then
      if kind == "install" or kind == "update" then
        if not ev.data.active then
          vim.cmd("packadd blink.lib")
          vim.cmd("packadd blink.cmp")
        end

        require("blink.cmp").build():pwait()
      end
    end
  end,
})
