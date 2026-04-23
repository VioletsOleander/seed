if vim.g.vscode then
	return nil
end

local au = vim.api.nvim_create_autocmd
local aug = vim.api.nvim_create_augroup

-- Completion
local completion_group = aug("user.completion", { clear = true })

-- cmdline autocompletion
au("CmdlineChanged", {
	group = completion_group,
	pattern = { ":", "/", "?" },
	callback = function()
		vim.fn.wildtrigger()
	end,
	desc = "Automatically show popup menu when typing in cmd line",
})

-- lsp autocompletion
au("LspAttach", {
	group = completion_group,
	pattern = "*",
	callback = function(event)
		local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
		end
	end,
})
