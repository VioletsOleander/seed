local g = vim.g

-- Leader key
g.mapleader = " "
g.maplocalleader = [[\]]

-- Avoid loading some builtin plugins
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_gzip = 1
g.loaded_tarPlugin = 1
g.loaded_zipPlugin = 1
g.loaded_tutor_mode_plugin = 1

g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

-- Others
g.disable_autoformat = false
