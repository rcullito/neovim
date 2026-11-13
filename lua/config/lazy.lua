-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- <leader><leader> toggles between buffers
vim.keymap.set('n', '<leader><leader>', '<c-^>')
-- quick-open
vim.keymap.set('', '<leader>f', '<cmd>GFiles<cr>')
-- search buffers
vim.keymap.set('n', '<leader>l', '<cmd>Buffers<cr>')

vim.keymap.set('n', '<leader>o', '<cmd>only<cr>')

vim.api.nvim_set_keymap("n", "<leader>bd", ":lua DeleteOtherBuffers()<CR>", { noremap = true })

function DeleteOtherBuffers()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
      pcall(vim.api.nvim_buf_delete, buf, {})
    end
  end
end


-- copy git forge URLs via forgelink (https://github.com/dpassen/forgelink)
if vim.fn.exepath('forgelink') ~= '' then
  vim.keymap.set('n', '<leader>cf',
    function()
      local curFile = vim.api.nvim_buf_get_name(0)
      local output = vim.fn.system({ 'forgelink', 'print', curFile })
      vim.fn.setreg('+', vim.trim(output))
    end,
    { desc = "Copy URL to Git forge for current file to clipboard" }
  )
  vim.keymap.set('v', '<leader>cf',
    function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
      local curFile = vim.api.nvim_buf_get_name(0)
      local startLine = vim.fn.line("'<")
      local endLine = vim.fn.line("'>")
      local lineRef = startLine == endLine and tostring(startLine) or (startLine .. '-' .. endLine)
      local output = vim.fn.system({ 'forgelink', 'print', curFile .. ':' .. lineRef })
      vim.fn.setreg('+', vim.trim(output))
    end,
    { desc = "Copy URL to Git forge for current file with selected line numbers to clipboard" }
  )
end

-- infinite undo!
-- NOTE: ends up in ~/.local/state/nvim/undo/
vim.opt.undofile = true

-- sidebar
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

-- nvim 0.11 turned off inline diagnostic text by default (gutter sign + underline
-- only). ALE used to paint messages at end of line; now that it is off for Rust,
-- have the built-in client do it.
vim.diagnostic.config({ virtual_text = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function(args)
    vim.lsp.buf.format({ async = false })
    -- work around nvim 0.11/0.12 inlay-hint "Invalid 'col': out of range" after rustfmt
    -- shortens lines: drop the stale hint cache and request fresh hints before any redraw.
    -- see https://github.com/neovim/neovim/issues/39772
    if vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }) then
      vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})



-- Who handles what: Neovim's built-in LSP client vs ALE
--
-- Rust (*.rs): rustaceanvim attaches rust-analyzer through the built-in client
--   (vim.lsp). That is what powers the gd/gr/<leader>a keymaps in rustacean.lua,
--   nvim-cmp completions, inlay hints, and the BufWritePre format above.
--   ALE is given an empty linter list for rust so it stays out entirely. With its
--   defaults it started a second rust-analyzer, ran cargo check on every save/edit,
--   and painted warnings as end-of-line virtual text that shifted wrapped lines.
--
-- Go (*.go): nothing here sets up a built-in LSP client for Go (nvim-lspconfig was
--   dropped when rustaceanvim came in), so ALE's defaults take over:
--   gofmt, golangci-lint, gopls, govet. ALE drives gopls through its OWN LSP
--   client, not vim.lsp, so the rustacean.lua keymaps and nvim-cmp do not apply
--   in Go buffers. Use ALE's commands instead: :ALEGoToDefinition,
--   :ALEFindReferences, :ALEHover, :ALERename, :ALEDetail, :ALEFix.
--
-- When ALE runs: on buffer enter, on save, 200ms after a normal-mode edit, and on
--   leaving insert mode. It only lints; it never formats on save unless
--   g:ale_fix_on_save is set.
vim.g.ale_linters = { rust = {} }

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
