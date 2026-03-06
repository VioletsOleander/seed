return {
    "justinmk/vim-sneak",
    event = "VeryLazy",
    init = function()
        -- use smartcase and ignorecase
        vim.g["sneak#use_ic_scs"] = 1
    end,
    config = function()
        local api = vim.api

        -- disable sneak-s and sneak-S
        vim.keymap.set({ 'n', 'x' }, '<Plug>(Disable-Sneak-s)', '<Plug>Sneak_s')
        vim.keymap.set({ 'n', 'x' }, '<Plug>(Disable-Sneak-S)', '<Plug>Sneak_S')

        -- disable highlight
        local function clear_sneak_highlight()
            api.nvim_set_hl(0, "Sneak", { link = "None" })
            api.nvim_set_hl(0, "SneakCurrent", { link = "None" })
        end

        clear_sneak_highlight()

        api.nvim_create_autocmd("ColorScheme", {
            callback = clear_sneak_highlight,
        })
        api.nvim_create_autocmd("User", {
            pattern = "SneakLeave",
            callback = clear_sneak_highlight,
        })
    end,
    keys = {
        { "f", "<Plug>Sneak_f", mode = { "n", "x", "o" }, desc = "Sneak Forward to" },
        { "F", "<Plug>Sneak_F", mode = { "n", "x", "o" }, desc = "Sneak Backward to" },
        { "t", "<Plug>Sneak_t", mode = { "n", "x", "o" }, desc = "Sneak Forward till" },
        { "T", "<Plug>Sneak_T", mode = { "n", "x", "o" }, desc = "Sneak Backward till" },
    },
}
