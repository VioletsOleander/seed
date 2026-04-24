if vim.g.vscode then
	return nil
end

vim.opt_local.colorcolumn = "120"
vim.opt_local.formatoptions:remove({ "r", "o" })
