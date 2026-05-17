local servers = {
	"bashls",
	"cssls",
	"html",
	"jsonls",
	"lua_ls",
	"pyright",
	"ruff",
	"rust_analyzer",
	"taplo",
	"ts_ls",
	"yamlls",
}

return {
	{
		"mason-org/mason.nvim",
		build = ":MasonUpdate",
		config = true,
		cmd = { "Mason", "MasonUpdate", "MasonLog", "MasonInstall", "MasonUninstall", "MasonUninstallAll" },
	},

	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim" },
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local mlsp = require("mason-lspconfig")
			mlsp.setup({
				ensure_installed = servers,
				automatic_installation = true,
			})

			vim.lsp.config("*", {
				capabilities = vim.lsp.protocol.make_client_capabilities(),
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
						completion = { callSnippet = "Replace" },
					},
				},
			})

			vim.lsp.enable(servers)
		end,
	},
}
