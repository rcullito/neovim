return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    dependencies = {
      'andymass/vim-matchup',
      {
        'JoosepAlviste/nvim-ts-context-commentstring',
        init = function()
          vim.g.skip_ts_context_commentstring_module = true
        end,
      },
      { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
      {
        'nvim-mini/mini.ai',
        opts = function()
          local ai = require('mini.ai')
          return {
            n_lines = 500,
            custom_textobjects = {
              o = ai.gen_spec.treesitter({ -- code block
                a = { '@block.outer', '@conditional.outer', '@loop.outer' },
                i = { '@block.inner', '@conditional.inner', '@loop.inner' },
              }),
              f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }), -- function
              c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }), -- class
              t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
              d = { '%f[%d]%d+' }, -- digits
              e = { -- Word with case
                { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
                '^().*()$',
              },
              u = ai.gen_spec.function_call(), -- u for "Usage"
              U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }), -- without dot in function name
            },
          }
        end,
      },
    },
    opts = {
      ensure_installed = {
        'bash',
        'json',
        'kdl',
        'lua',
        'markdown',
        'markdown_inline',
        'regex',
        'vim',
        'vimdoc',
      },
    },
    config = function(_, opts)
      require('nvim-treesitter').install(opts.ensure_installed)

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('tree-sitter setup', { clear = true }),
        callback = function(args)
          local ft = args.match
          local lang = vim.treesitter.language.get_lang(ft)
          if lang and vim.treesitter.language.add(lang) then
            vim.treesitter.start(args.buf, lang)
            vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
            if vim.wo.foldexpr == '0' then
              vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            end
          end
        end,
      })
    end,
  },
}