local api = vim.api

if not vim.g.vscode then
	-- reset cursor when exit
	api.nvim_create_autocmd("VimLeave", {
		pattern = "*",
		callback = function()
			vim.opt.guicursor = ""
			vim.fn.chansend(vim.v.stderr, "\x1b[0 q")
		end,
	})
end
