local function on_insert()
  local safely = require("util").safely

  vim.pack.add({
    "https://github.com/windwp/nvim-autopairs",
    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/saghen/blink.lib",
    "https://github.com/saghen/blink.cmp",
  })

  --- Nvim-autopairs.

  safely(function()
    require("nvim-autopairs").setup({ check_ts = true })
  end)

  --- Blink.cmp.

  safely(function()
    local opts = {
      keymap = {
        preset = "none",
        ["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-f>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      },
      signature = {
        enabled = false,
        window = { show_documentation = true },
      },
      -- Use require("blink.cmp").reload("snippets") to reload snippets.
      sources = { default = { "lsp", "snippets", "buffer" } },
      fuzzy = { implementation = "rust" },
      completion = {
        list = { selection = { auto_insert = false } },
        accept = { auto_brackets = { enabled = false } },
        documentation = { auto_show = false },
        menu = {
          draw = {
            columns = { { "kind_icon" }, { "label" }, { "kind" } },
            components = {
              kind_icon = {
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
              },
            },
          },
        },
      },
      cmdline = {
        keymap = {
          preset = "none",
          ["<Tab>"] = { "select_next", "fallback" },
          ["<S-Tab>"] = { "select_prev", "fallback" },
          ["<C-e>"] = { "hide", "fallback" },
          ["<C-j>"] = { "select_next", "fallback" },
          ["<C-k>"] = { "select_prev", "fallback" },
          ["<C-f>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
        },
        completion = {
          menu = {
            draw = { columns = { { "label", "label_description", gap = 1 }, { "kind" } } },
            auto_show = true,
          },
          list = {
            selection = {
              preselect = false,
              auto_insert = true,
            },
          },
        },
      },
    }

    require("blink.cmp").setup(opts)
  end)
end

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  once = true,
  group = vim.api.nvim_create_augroup("user", { clear = false }),
  callback = on_insert,
})

vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("user", { clear = false }),
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    if name == "blink.cmp" and (kind == "install" or kind == "update") then
      if not ev.data.active then
        vim.cmd.packadd("blink.cmp")
      end

      require("blink.cmp").build():pwait()
    end
  end,
})
