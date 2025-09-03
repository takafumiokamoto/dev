return {
  'nvim-java/nvim-java',
  dependencies = {
    'neovim/nvim-lspconfig',
    'mfussenegger/nvim-dap',
    'mason-org/mason.nvim',
  },
  config = function()
    require('java').setup()
    require('lspconfig').jdtls.setup({})
  end,
}