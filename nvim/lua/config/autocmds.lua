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
	api.nvim_create_autocmd("LspAttach", {
		group = api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(event)
			-- Helper function to set keymaps with buffer and description
			local map = function(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = "LSP: " .. desc })
			end
			local lsp = vim.lsp

			-- Navigation
			map("n", "gd", lsp.buf.definition, "Go to Definition")
			map("n", "gr", lsp.buf.references, "Show References")
			map("n", "gD", lsp.buf.declaration, "Go to Declaration")
			map("n", "gi", lsp.buf.implementation, "Go to Implementation")
			map("n", "gy", lsp.buf.type_definition, "Go to Type Definition")

			-- Documentation & Information
			map("n", "gh", lsp.buf.hover, "Hover Documentation")
			map("n", "gH", lsp.buf.signature_help, "Signature Help")

			-- Refactoring & Actions
			map("n", "<leader>r", lsp.buf.rename, "Rename Symbol")
			map({ "n", "v" }, "<leader>a", lsp.buf.code_action, "Code Action")

			-- Diagnostics
			map("n", "<leader>d", vim.diagnostic.open_float, "Line Diagnostics")
			map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
			map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
		end,
	})
end
