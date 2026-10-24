---@module "lazy"
---@module "flash"

---@type Flash.Config
local flash_opts = {
  labels = "asdfghjkl;qwertyuiopzxcvbnm",
  search = {
    -- The cursor will flick when search multi_window, so disable it
    multi_window = false,
    exclude = {
      "snacks_picker_input",
      "flash_prompt",
      function(win)
        return not vim.api.nvim_win_get_config(win).focusable
      end,
    },
  },
  highlight = { backdrop = false },
  label = { uppercase = true },
  modes = {
    char = {
      config = function(opts)
        -- opts.label.after = true
      end,
      label = { exclude = ";hjkliardc" },
      jump_labels = true,
      highlight = { backdrop = false },
      char_actions = function(motion)
        return {
          [";"] = "right",
          [","] = "left",
          [motion:lower()] = "right",
          [motion:upper()] = "left",
        }
      end,
      jump = {
        autojump = true,
      },
    },
    treesitter = { jump = { autojump = false } },
  },
}

local function set_flash_keymaps()
  local map = vim.keymap.set

  -- Regular keymaps
  map({ "n", "o", "x" }, "s", function()
    require("flash").jump()
  end, { desc = "Jump to visible word by searching" })
  map({ "n", "o", "x" }, "<C-s>", function()
    require("flash").jump({ continue = true })
  end, { desc = "Continue last flash jump" })
  map({ "n", "o", "x" }, "gs", function()
    require("flash").treesitter()
  end, { desc = "Select visible parent treesitter node" })
  map("o", "r", function()
    require("flash").remote()
  end, { desc = "Jump to visible place by searching. Jump back after finishing operator" })
  map({ "o", "x" }, "R", function()
    require("flash").treesitter_search()
  end, { desc = "Select range by searching neighboring treesitter node" })

  -- Custom keymaps
  map({ "n", "o", "x" }, "gl", function()
    require("flash").jump({
      search = { mode = "search", max_length = 0 },
      pattern = "^",
      label = {
        after = { 0, 0 },
        format = function(opts)
          return {
            { opts.match.label1, "FlashMatch" },
            { opts.match.label2, "FlashMatch" },
          }
        end,
      },
      action = function(match, state)
        state:hide()
        require("flash").jump({
          search = { max_length = 0 },
          label = {
            format = function(opts)
              return { { opts.match.label2, "FlashMatch" } }
            end,
          },
          highlight = { matches = false },
          matcher = function(win)
            -- Limit matches to the current selected label
            return vim.tbl_filter(function(m)
              return m.label1 == match.label1 and m.win == win
            end, state.results)
          end,
          labeler = function(matches)
            for _, m in ipairs(matches) do
              m.label = m.label2
            end
          end,
        })
      end,
      labeler = function(matches, state)
        local labels = state:labels()
        for i, match in ipairs(matches) do
          -- Each 10 lines share the same first label
          match.label1 = labels[math.floor((i - 1) / 10) + 1]
          match.label2 = labels[(i - 1) % 10 + 1]
          match.label = match.label1
        end
      end,
    })
  end, { desc = "Jump to a visible line." })
end

-- Customize char mode to show label for the first "f/F" match.

---@type table<Flash.Char.Motion, Flash.State.Config>
local flash_char_motions = {
  f = { label = { after = true, before = false } },
  t = {},
  F = {
    jump = { inclusive = false },
    search = { forward = false },
    label = { after = true, before = false },
  },
  T = {
    jump = { inclusive = false },
    search = { forward = false },
    label = { before = true, after = false },
  },
}

local function flash_char_new()
  local module = require("flash.plugins.char")

  local opts = require("flash.config").get({
    mode = "char",
    labeler = module.labeler,
    search = {
      multi_window = false,
      mode = module.mode(module.motion),
      max_length = 1,
    },
    prompt = {
      enabled = false,
    },
  }, module.motions[module.motion])

  -- Exclude the motion labels so we can use them for next/prev.
  opts.labels = opts.labels:gsub(module.motion:lower(), "")
  opts.labels = opts.labels:gsub(module.motion:upper(), "")

  return require("flash.state").new(opts)
end

---@type LazyPluginSpec
local flash_nvim = {
  "folke/flash.nvim",
  event = "VeryLazy",
  config = function()
    require("flash.plugins.char").motions = flash_char_motions
    require("flash.plugins.char").new = flash_char_new

    set_flash_keymaps()
    require("flash").setup(flash_opts)
  end,
}

return { flash_nvim }
