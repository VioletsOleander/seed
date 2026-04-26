if vim.g.vscode then
	return nil
end

vim.opt_local.spell = true

vim.opt_local.autocomplete = false
vim.opt_local.completeopt = "menu,popup"
vim.b.completion = false
