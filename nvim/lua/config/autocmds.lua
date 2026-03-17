local autocmd = vim.api.nvim_create_autocmd

if not vim.g.vscode then
	-- format on save
	autocmd("BufWritePre", {
		pattern = { "*.lua", "*.py" },
		callback = function(event)
			vim.lsp.buf.format({ bufnr = event.buf })
		end,
		desc = "Format on save by lsp",
	})
	-- format on save (for those without lsp format support)
	autocmd("BufWritePre", {
		pattern = { "*.yaml", "*.yml" },
		callback = function(event)
			require("conform").format({ bufnr = event.buf })
		end,
		desc = "Format on save by conform.nvim",
	})
	-- set kemaps when lsp attaches to buffer
	autocmd("LspAttach", {
		pattern = "*",
		callback = function(event)
			local buf = vim.lsp.buf
			local diagnostic = vim.diagnostic

			local map = function(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = "LSP: " .. desc })
			end

			map("n", "gD", buf.declaration, "Go to Declaration")

			map("n", "K", buf.hover, "Hover Documentation")
			map("i", "<C-k>", buf.signature_help, "Signature Help")

			map("n", "<Leader>r", buf.rename, "Rename Symbol")
			map({ "n", "v" }, "<Leader>a", buf.code_action, "Code Action")

			map("n", "<Leader>cd", diagnostic.open_float, "Show Line Diagnostics")
			map("n", "[d", function()
				diagnostic.jump({ count = 1, float = true })
			end, "Prev Diagnostic")
			map("n", "]d", function()
				diagnostic.jump({ count = -1, float = true })
			end, "Next Diagnostic")
		end,
	})
end
