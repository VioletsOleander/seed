return {
    "justinmk/vim-sneak",
    event = "VeryLazy",
    init = function()
        -- use smartcase and ignorecase
        vim.g["sneak#use_ic_scs"] = 1

        -- disable highlight
        vim.api.nvim_set_hl(0, "Sneak", { link = "None" })
        vim.api.nvim_set_hl(0, "SneakScope", { link = "None" })
        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = function()
                vim.api.nvim_set_hl(0, 'Sneak', { link = 'None' })
                vim.api.nvim_set_hl(0, 'SneakScope', { link = 'None' })
            end,
        })
        vim.api.nvim_create_autocmd("User", {
            pattern = "SneakLeave",
            callback = function()
                vim.cmd("highlight clear Sneak")
                vim.cmd("highlight clear SneakCurrent")
                vim.cmd("highlight clear SneakScope")
            end,
        })
    end,
}
