return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    -- consider use treesitter-textobjects and highlights for some
    -- files types I often operate on later
    -- now just leave it unused util I have time to configure it
    enabled = false,
}
