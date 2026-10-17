return {
	"neovim/nvim-lspconfig",

	event = {
		"BufReadPre",
		"BufNewFile",
	},
	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		--------------------------------------------------
		-- Lua
		--------------------------------------------------
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})

		--------------------------------------------------
		-- Go (gopls)
		--------------------------------------------------
		vim.lsp.config("gopls", {
			capabilities = capabilities,
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
					gofumpt = true, -- Cleaner Go formatting rules
				},
			},
		})

		--------------------------------------------------
		-- Enable Servers
		--------------------------------------------------
		vim.lsp.enable("lua_ls")
		vim.lsp.enable("gopls")
		vim.lsp.enable("ts_ls")

		--------------------------------------------------
		-- Auto-format on save for Go files
		--------------------------------------------------
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.go",
			callback = function()
				local params = vim.lsp.util.make_range_params()
				params.context = { only = { "source.organizeImports" } }

				-- Sync code action to organize imports (gopls native handling)
				local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
				for _, res in pairs(result or {}) do
					for _, r in pairs(res.result or {}) do
						if r.edit then
							vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
						else
							vim.lsp.buf.execute_command(r.command)
						end
					end
				end

				-- Run standard code formatting
				vim.lsp.buf.format({ async = false })
			end,
		})

		--------------------------------------------------
		-- Diagnostics
		--------------------------------------------------
		vim.diagnostic.config({
			virtual_text = true,
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,

			float = {
				border = "rounded",
				source = "if_many",
			},
		})
	end,
}
