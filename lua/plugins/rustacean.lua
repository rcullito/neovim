return {
  'mrcjkb/rustaceanvim',
  version = '^6', -- Recommended
  lazy = false, -- This plugin is already lazy
  config = function()
	vim.api.nvim_create_autocmd('LspAttach', {
		callback = function(ev)
			vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
			vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
			vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
			vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
			vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
			vim.keymap.set("n", "<leader>t", function()
			  vim.cmd.RustLsp("testables")
			end, { desc = "Run Rust test" })
		end
	})
  end
}
