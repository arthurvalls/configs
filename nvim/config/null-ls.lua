local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.google_java_format, 
    null_ls.builtins.diagnostics.checkstyle,       

    null_ls.builtins.formatting.autopep8,            
    null_ls.builtins.diagnostics.flake8,             
    null_ls.builtins.diagnostics.mypy,               

    null_ls.builtins.formatting.prettier.with({
      filetypes = {"javascript", "javascriptreact", "typescript", "typescriptreact"},
    }),              
    
    null_ls.builtins.formatting.rustfmt,              
    
    null_ls.builtins.formatting.prettier.with({
      filetypes = {"json"}, 
      }),               
      },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = {"*"},
  callback = function()
    vim.lsp.buf.format()
  end,
})
