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

  ---@param opts Flash.Format
  local function get_label_formats(opts)
    return {
      { opts.match.label1, "FlashMatch" },
      { opts.match.label2, "FlashMatch" },
    }
  end

  map("n", "gl", function()
    require("flash").jump({
      search = { mode = "search", max_length = 0 },
      pattern = "^",
      label = { after = { 0, 0 }, format = get_label_formats },
      ---@param match Flash.Match
      ---@param state Flash.State
      action = function(match, state)
        state:hide()
        require("flash").jump({
          search = { max_length = 0 },
          label = { format = get_label_formats },
          highlight = { matches = false },
          ---@param win number
          matcher = function(win)
            -- Limit matches to the current label
            return vim.tbl_filter(function(m)
              return m.label1 == match.label1 and m.win == win
            end, state.results)
          end,
          ---@param matches Flash.Match[]
          labeler = function(matches)
            for _, m in ipairs(matches) do
              m.label = m.label2
            end
          end,
        })
      end,
      ---@param matches Flash.Match[]
      ---@param state Flash.State
      labeler = function(matches, state)
        local labels = state:labels()
        for i, match in ipairs(matches) do
          match.label1 = labels[math.floor((i - 1) / #labels) + 1]
          match.label2 = labels[(i - 1) % #labels + 1]
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
