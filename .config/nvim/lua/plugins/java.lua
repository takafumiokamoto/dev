return {
	"mfussenegger/nvim-jdtls",
	dependencies = { "neovim/nvim-lspconfig" },
	config = function()
		-- In the previous step, we set up a general lspconfig handler.
		-- We now override it for the 'jdtls' server to use nvim-jdtls's
		-- specialized configuration.

		local lspconfig = require("lspconfig")
		local jdtls = require("jdtls")

		-- Define the location of your JDKs.
		-- This is optional if you have only one and JAVA_HOME is set.
		-- If you have multiple JDKs, you can specify them here.
		-- Example:
		-- local jdks = {
		--   { name = 'openjdk-17', path = '/usr/lib/jvm/java-17-openjdk-amd64' },
		--   { name = 'openjdk-21', path = '/usr/lib/jvm/java-21-openjdk-amd64' },
		-- }

		-- This is the heart of the nvim-jdtls setup.
		-- It defines the command to start the server and the settings to use.
		local config = {
			-- The command that starts the language server.
			-- We use the `jdtls.launcher` function to generate this.
			cmd = jdtls.start_command({
				-- The `-data` argument is crucial. It tells jdtls where to store its
				-- workspace data for the current project.
				data = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
			}),

			-- The `root_dir` function tells jdtls where the project root is.
			-- It looks for common project files like build.gradle, pom.xml, etc.
			root_dir = require("jdtls.setup").find_root({
				"build.gradle",
				"build.gradle.kts",
				"pom.xml",
				".git",
			}),

			-- This is the `on_attach` function that will be called when jdtls
			-- attaches to a buffer.
			on_attach = function(client, bufnr)
				-- As requested, we are not setting keymaps here.
				-- This is where you would add Java-specific keymaps.

				-- This is the recommended way to start jdtls's extended features.
				jdtls.setup_dap({ hotcodereplace = "auto" })
				jdtls.setup.add_commands()
			end,

			-- You can add other settings here if needed.
			-- For example, to use a specific JDK for a project:
			-- settings = {
			--   java = {
			--     configuration = {
			--       runtimes = jdks
			--     }
			--   }
			-- }
		}

		-- Finally, we apply this configuration to the 'jdtls' server.
		lspconfig.jdtls.setup(config)
	end,
}
