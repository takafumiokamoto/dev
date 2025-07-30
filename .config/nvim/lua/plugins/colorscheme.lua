return {
  {
    'JoosepAlviste/palenightfall.nvim',
    priority = 1000,
    enabled = true,
    config = function()
      local palenight = require 'palenightfall'
      palenight.setup {
        transparent = true,
        italic = true,
      }
      vim.cmd 'colorscheme palenightfall'
    end,
  },
  {},
}
