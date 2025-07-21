return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup({
      options = {
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 
          'filename',
          -- LSP server name and status
          {
            function()
              local clients = vim.lsp.get_active_clients({ bufnr = 0 })
              if #clients == 0 then
                return ""
              end
              
              local client_names = {}
              for _, client in ipairs(clients) do
                table.insert(client_names, client.name)
              end
              return " LSP: " .. table.concat(client_names, ", ")
            end,
            icon = "",
            color = { fg = '#61afef' },
          }
        },
        lualine_x = { 
          -- LSP progress (shows when rust-analyzer is working)
          {
            function()
              local messages = vim.lsp.util.get_progress_messages()
              if #messages == 0 then
                return ""
              end
              
              local status = {}
              for _, msg in ipairs(messages) do
                local title = msg.title or ""
                local percentage = msg.percentage or 0
                local client_name = msg.name or ""
                
                if title ~= "" then
                  table.insert(status, string.format("%s: %s (%d%%)", client_name, title, percentage))
                end
              end
              
              if #status == 0 then
                return ""
              end
              
              return " " .. table.concat(status, " | ")
            end,
            icon = "",
            color = { fg = '#e06c75' },
          },
          'encoding', 
          'fileformat', 
          'filetype' 
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
    })
  end,
}
