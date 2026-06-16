-- Starts/attaches jdtls for every java buffer. nvim-jdtls is lazy-loaded on
-- ft=java, so on the very first java file this may run before the plugin is
-- ready; lazy.nvim re-emits FileType after loading it, and this ftplugin runs
-- again (no did_ftplugin guard), so the pcall simply no-ops on the first pass
-- and succeeds on the retry. start_or_attach is idempotent.
pcall(function()
  require("jdtls_setup").setup()
end)
