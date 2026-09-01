vim.keymap.set("i", "jj", "<Esc>", {
	noremap = true,
	silent = true,
})

vim.keymap.set("v", "<C-c>", "+y")
vim.keymap.set("n", "<C-v>", "+p")
vim.keymap.set("i", "<C-v>", "<C-r>+")

-- Yank entire file
vim.keymap.set("n", "yig", "ggyG", {
	desc = "Yank entire file",
})

-- Delete entire file
vim.keymap.set("n", "dig", "ggdG", {
	desc = "Delete entire file",
})

--------------------------------------------------
-- LSP
--------------------------------------------------

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local opts = {
			buffer = event.buf,
			silent = true,
		}

		-- Navigation
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)

		-- Information
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

		-- Code Actions
		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename", buffer = event.buf })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action", buffer = event.buf })

		-- Formatting
		vim.keymap.set("n", "<leader>cf", function()
			vim.lsp.buf.format({ async = true })
		end, { desc = "Format", buffer = event.buf })

		-- Diagnostics
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
		vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics", buffer = event.buf })
		vim.keymap.set("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Diagnostics List", buffer = event.buf })

		-- Workspace
		vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)

		-- Inlay Hints (Neovim 0.10+)
		if vim.lsp.inlay_hint then
			vim.keymap.set("n", "<leader>uh", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			end, { desc = "Toggle Inlay Hints", buffer = event.buf })
		end
	end,
})

vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({
		async = true,
		lsp_format = "fallback",
	})
end, {
	desc = "Format",
})
