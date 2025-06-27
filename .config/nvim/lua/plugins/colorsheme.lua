return {
    "alexmozaidze/palenight.nvim",
    priority = 1000,
    enabled = true,
    config = function()
      local palenight = require("palenight")
      palenight.setup({
        italic = true
      })
      vim.cmd("colorscheme palenight")
    end,
}