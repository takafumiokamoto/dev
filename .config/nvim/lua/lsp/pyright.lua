return {
	settings = {
		python = {
			pythonPath = ".venv/bin/python",
		},
	},
	cmd = {
		"pyright",
	},
	filetypes = {
		"py",
	},
	root_markers = {
		".git",
		".venv",
		".pyproject.toml",
	},
	single_file_support = true,
	log_level = vim.lsp.protocol.MessageType.Warning,
}

