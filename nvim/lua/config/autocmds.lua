if vim.g.vscode then
	return nil
end

local au = vim.api.nvim_create_autocmd
local aug = vim.api.nvim_create_augroup

-- Hold autocmds done by native functions
local native_group = aug("user.native", { clear = true })
-- Hold autocmds done by lsp-related functions
local lsp_group = aug("user.lsp", { clear = true })

if vim.g.user_use_builtin_completion then
	-- Lsp autocompletion
	au("LspAttach", {
		group = lsp_group,
		pattern = "*",
		callback = function(ev)
			local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
			if not client:supports_method("textDocument/completion") then
				vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
			end
		end,
	})
else
	-- Cmdline autocompletion (Cmdline completion of blink.cmp is weird, so resort to default method)
	au("CmdlineChanged", {
		group = native_group,
		pattern = { ":", "/", "?" },
		callback = function()
			vim.fn.wildtrigger()
		end,
		desc = "Automatically show popup menu when typing in cmd line",
	})
end

-- Help
au("FileType", {
	group = native_group,
	pattern = "help",
	callback = function()
		vim.cmd("wincmd L")
	end,
})

-- Highlight
au("TextYankPost", {
	group = native_group,
	pattern = "*",
	callback = function()
		vim.hl.on_yank()
	end,
	desc = "Hilight on yank",
})

-- Lsp keymaps
au("LspAttach", {
	group = lsp_group,
	pattern = "*",
	callback = function(ev)
		--- Help function to set buffer local keymap
		---
		---@param modes string|string[] Mode "short-name" (see |nvim_set_keymap()|), or a list thereof.
		---@param lhs string Left-hand side |{lhs}| of the mapping.
		---@param rhs string|function Right-hand side |{rhs}| of the mapping, can be a Lua function.
		---@param desc string Description
		local function map_local(modes, lhs, rhs, desc)
			vim.keymap.set(modes, lhs, rhs, { buf = ev.buf, desc = desc })
		end

		-- Lsp gotos
		map_local("n", "gd", vim.lsp.buf.definition, "Go to definition")
		map_local("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
		map_local("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
		map_local("n", "gi", vim.lsp.buf.implementation, "Go to implementation")

		-- LSP shows
		map_local("n", "gr", vim.lsp.buf.references, "Show references")
		map_local("i", "gk", vim.lsp.buf.signature_help, "Show signature help")

		-- LSP actions
		map_local("n", "<Leader>r", vim.lsp.buf.rename, "Rename symbol")

		map_local("n", "<Leader>a", vim.lsp.buf.code_action, "Code action")
	end,
})
