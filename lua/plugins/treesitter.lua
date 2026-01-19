return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    -- Use 'config' (no 's') for the new main branch
    local configs = require("nvim-treesitter.config")

    configs.setup({
      ensure_installed = { "rust", "lua", "vim", "vimdoc", "query" },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}