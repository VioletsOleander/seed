if vim.g.vscode then
	return nil
end

vim.opt_local.formatoptions:remove({ "r", "o" })
