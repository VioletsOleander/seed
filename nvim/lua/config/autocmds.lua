local api = vim.api
local autocmd = api.nvim_create_autocmd

if not vim.g.vscode then
	-- reset cursor when exit
	autocmd("VimLeave", {
		pattern = "*",
		callback = function()
			vim.opt.guicursor = ""
			vim.fn.chansend(vim.v.stderr, "\x1b[0 q")
		end,
	})
	-- set kemaps when lsp attaches to buffer
	autocmd("LspAttach", {
		group = api.nvim_create_augroup("UserLspConfig", { clear = true }),
		callback = function(event)
			local map = function(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = "LSP: " .. desc })
			end

			local buf = vim.lsp.buf
			local diagnostic = vim.diagnostic

			local has_telescope, builtin = pcall(require, "telescope.builtin")

			if has_telescope then
				map("n", "gd", builtin.lsp_definitions, "Go to Definition")
				map("n", "gr", builtin.lsp_references, "Show References")
				map("n", "gi", builtin.lsp_implementations, "Go to Implementation")
				map("n", "gy", builtin.lsp_type_definitions, "Go to Type Definition")

				map("n", "<Leader>ss", builtin.lsp_document_symbols, "Document Symbols")
				map("n", "<Leader>sw", builtin.lsp_dynamic_workspace_symbols, "Workspace Symbols")
				map("n", "<Leader>d", function()
					builtin.diagnostics({ bufnr = 0 })
				end, "Show Diagnostics in Current Buffer")
				map("n", "<Leader>D", builtin.diagnostics, "Show Diagnostics in Workspace")
			else
				map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
				map("n", "gr", vim.lsp.buf.references, "References")
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
