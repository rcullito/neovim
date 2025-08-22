return {
  'mrcjkb/rustaceanvim',
  version = '^6', -- Recommended
  lazy = false, -- This plugin is already lazy
  dependencies = {

	"williamboman/mason.nvim",
  },
  config = function()

	         local mason_registry = require('mason-registry')
                    if not mason_registry.is_installed('codelldb') then
                        error('codelldb is not installed. Run :MasonInstall codelldb')
                    end




      local cfg = require('rustaceanvim.config')
    vim.g.rustaceanvim = {

      server = {
	on_attach = function(client, bufnr)
			vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
			vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
			vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
			vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
			vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
			vim.keymap.set("n", "<leader>t", function()
			  vim.cmd.RustLsp("testables")
			end, { desc = "Run Rust test" })
    	end,

        settings = {
          ["rust-analyzer"] = {
	     -- these settings affect what was rustaceanvim's project wide settings for clippy
	     -- a default rust-analyzer process will still run for the current crate with command = check
            checkOnSave = false,
          },
        },
      },
    }
  end
}
