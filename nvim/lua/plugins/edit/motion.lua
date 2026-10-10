---@module "lazy"
---@module "flash"

---@type Flash.Config
local flash_opts = {
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
  highlight = {
    backdrop = false,
  },
  label = {
    uppercase = false,
  },
  modes = {
    char = {
      highlight = {
        backdrop = false,
      },
      char_actions = function()
        return {
          [";"] = "right",
          [","] = "left",
        }
      end,
    },
    treesitter = {
      jump = { autojump = false },
    },
  },
}

local function set_flash_keymaps()
  local map = vim.keymap.set

  -- Regular keymaps
  map({ "n", "o", "x" }, "s", function()
    require("flash").jump()
  end, { desc = "Jump to visible word by searching" })
  map({ "n", "o", "x" }, "gs", function()
    require("flash").treesitter()
  end, { desc = "Select visible parent treesitter node" })
  map("o", "r", function()
    require("flash").remote()
  end, { desc = "Jump to visible word by searching. Jump back after finishing operator" })
  map({ "o", "x" }, "R", function()
    require("flash").treesitter_search()
  end, { desc = "Select range by searching neighboring treesitter node" })

  -- Custom keymaps
  map("n", "gl", function()
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

---@type LazyPluginSpec
local flash_nvim = {
  "folke/flash.nvim",
  event = "VeryLazy",
  config = function()
    set_flash_keymaps()
    require("flash").setup(flash_opts)
  end,
}

return { flash_nvim }
