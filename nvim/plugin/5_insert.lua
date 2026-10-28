---@module "blink.cmp"

local function setup_nvim_autopairs()
  require("nvim-autopairs").setup({ check_ts = true })
end

local function setup_nvim_surround()
  require("nvim-surround").setup({ move_cursor = "sticky" })
end

local function setup_blink_cmp()
  ---@type blink.cmp.Config
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
    signature = { enabled = false, window = { show_documentation = true } },
    completion = {
      list = {
        selection = {
          auto_insert = false,
        },
      },
      accept = {
        dot_repeat = false,
        auto_brackets = {
          enabled = false,
        },
      },
      documentation = { auto_show = false },
      menu = {
        draw = {
          columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } },
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
    sources = { default = { "lsp", "snippets", "buffer" } },
    fuzzy = { implementation = "rust" },
    cmdline = {
      enabled = false,
      keymap = {
        preset = "none",
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
      },
      completion = {
        menu = { auto_show = true },
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
end

local au = vim.api.nvim_create_autocmd

au("InsertEnter", {
  once = true,
  callback = function()
    vim.pack.add({
      "https://github.com/windwp/nvim-autopairs",
      "https://github.com/rafamadriz/friendly-snippets",
      "https://github.com/saghen/blink.lib",
      "https://github.com/saghen/blink.cmp",
    })

    setup_nvim_autopairs()
    setup_blink_cmp()
  end,
})

au("VimEnter", {
  callback = function()
    vim.schedule(function()
      vim.pack.add({ "https://github.com/kylechui/nvim-surround" })
      setup_nvim_surround()
    end)
  end,
})

au("PackChanged", {
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
