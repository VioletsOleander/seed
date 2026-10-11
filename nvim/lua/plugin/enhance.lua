---@module "lazy"

---@type LazyPluginSpec
local nvim_surround = {
  "kylechui/nvim-surround",
  event = "VeryLazy",
}

---@type LazyPluginSpec
local nvim_autopair = {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,
  },
}

---@type LazyPluginSpec
local grug_far_nvim = {
  "MagicDuck/grug-far.nvim",
  cmd = { "GrugFar", "GrugFarWithin" },
}

return { nvim_surround, nvim_autopair, grug_far_nvim }
