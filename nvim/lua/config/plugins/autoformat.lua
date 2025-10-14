return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = false, cpp = false, java = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      java = {},
      python = { 'black' }, -- you can add isort and ruff
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      -- javascriptreact = { 'prettierd', 'prettier', stop_after_first = true }, -- .jsx
      -- typescriptreact = { 'prettierd', 'prettier', stop_after_first = true }, -- .tsx
      -- if you want ESLint autofix before formatting:
      javascriptreact = { 'eslint_d', 'prettierd', stop_after_first = false },
      typescriptreact = { 'eslint_d', 'prettierd', stop_after_first = false },
      json = { 'prettierd', 'prettier', 'jd', stop_after_first = true },
      markdown = { 'prettierd', 'prettier', 'jd', stop_after_first = true },
    },
  },
}
