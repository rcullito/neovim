return {
	"mrcjkb/rustaceanvim",
	version = "^8", -- Recommended
	lazy = false, -- This plugin is already lazy
        ft = "rust",
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'jay-babu/mason-nvim-dap.nvim',
        },
        opts = function(_, opts)
            require('mason-nvim-dap').setup({
                ensure_installed = { "codelldb" },
            })
        end,
	config = function()
		local cfg = require("rustaceanvim.config")
		vim.g.rustaceanvim = {

			server = {
				on_attach = function(client, bufnr)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>m", "<cmd>marks<CR>", { desc = "List marks" })
					vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>t", function()
						vim.cmd.RustLsp("testables")
					end, { desc = "Run Rust test" })
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end,

				settings = {
					["rust-analyzer"] = {
						-- Run `cargo check` on save so rustc-only diagnostics show up
						-- (unused Result, borrowck, missing trait items, ...). rust-analyzer's
						-- native diagnostics do not cover those. workspace = false checks only
						-- the saved file's package, not the whole workspace. The 'default
						-- process' that used to do this was ALE's rust-analyzer, now disabled.
						checkOnSave = true,
						check = { workspace = false },
						inlayHints = {
							implicitDrops = {
								enable = true,
							},
							lifetimeElisionHints = {
								enable = "always",
								useParameterNames = true,
							},
						},
					},
				},
			},
		}
	end,
}
