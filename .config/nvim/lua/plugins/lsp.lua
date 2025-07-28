return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		-- This is where we will configure our LSPs.

		-- The on_attach function is a callback that runs whenever an LSP server
		-- attaches to a buffer. We will use it to set buffer-local options
		-- and mappings.
		local on_attach = function(client, bufnr)
			-- As requested, we are not setting keymaps here.
			-- This is a good place for other buffer-local settings.
			-- For example, enabling semantic highlighting.
			vim.lsp.buf.document_highlight()
			vim.lsp.buf.references()

			-- You could also set options like this:
			-- vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
		end

		-- The capabilities object tells the LSP server which features the client
		-- (Neovim) supports. We will enhance this later with our completion
		-- plugin's capabilities.
		local capabilities = vim.lsp.protocol.make_client_capabilities()

		-- Set up mason.nvim. It will handle the installation of LSPs.
		require("mason").setup()

		-- Set up mason-lspconfig.nvim. It will bridge mason and lspconfig.
		local mason_lspconfig = require("mason-lspconfig")

		mason_lspconfig.setup({
			-- A list of servers to automatically install if they are not already
			-- installed. We want jdtls for Java.
			ensure_installed = { "jdtls" },
		})

		-- This is the crucial part.
		-- This function gets called for every server that is installed via Mason.
		-- It sets up the server with lspconfig, applying our on_attach function
		-- and capabilities object to every one of them.
		mason_lspconfig.setup_handlers({
			function(server_name) -- Default handler
				require("lspconfig")[server_name].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
		})
	end,
}
