-- ~/.config/nvim/lua/jdtls_setup.lua
local M = {}

function M.setup()
  local jdtls = require("jdtls")
  local home = os.getenv("HOME")
  local jdtls_dir = home .. "/jdtls"
  -- Use vim.fn.glob to get the launcher jar file
  local launcher_jar = vim.fn.glob(jdtls_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar")

  if launcher_jar == "" then
    print("Could not find the jdtls launcher jar in " .. jdtls_dir .. "/plugins")
    return
  end

  local workspace_folder = home .. "/.cache/jdtls-workspace/" ..
    vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

  -- Create the workspace directory if it doesn't exist
  os.execute("mkdir -p " .. workspace_folder)

  -- Load java-debug-adapter + vscode-java-test bundles so DAP and neotest-java work.
  local bundles = {}
  local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
  local debug_jars = vim.fn.glob(mason_path .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true, true)
  vim.list_extend(bundles, debug_jars)
  local test_jars = vim.split(vim.fn.glob(mason_path .. "/java-test/extension/server/*.jar", true), "\n", { trimempty = true })
  vim.list_extend(bundles, test_jars)

  local config = {
    cmd = {
      "java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xms1g",
      "-Xmx4g",
      "-XX:+UseG1GC",
      "-XX:+UseStringDeduplication",
      "--add-modules=ALL-SYSTEM",
      "--add-opens", "java.base/java.util=ALL-UNNAMED",
      "--add-opens", "java.base/java.lang=ALL-UNNAMED",
      "-jar", launcher_jar,
      "-configuration", jdtls_dir .. "/config_linux",  -- adjust if on a different OS
      "-data", workspace_folder,
    },
    root_dir = require("jdtls.setup").find_root({".git", "mvnw", "gradlew", "pom.xml", "build.gradle"}),
    settings = {
      java = {
        format = {
          enabled = true,
          settings = {
            -- adjust these according to your preferred formatter configuration
	    url = "../java-formatter.xml",
	    profile = "GoogleStyle",
          },
        },
        signatureHelp = { enabled = true },
        contentProvider = { preferred = "fernflower" },
        completion = {
          favoriteStaticMembers = {
            "org.junit.Assert.*",
            "org.junit.Assume.*",
            "org.junit.jupiter.api.Assertions.*",
            "org.junit.jupiter.api.Assumptions.*",
            "org.junit.jupiter.api.DynamicContainer.*",
            "org.junit.jupiter.api.DynamicTest.*",
            "org.mockito.Mockito.*",
            "org.mockito.ArgumentMatchers.*",
            "org.mockito.Answers.*",
          },
          importOrder = { "java", "javax", "com", "org" },
        },
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        codeGeneration = {
          toString = {
            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
          },
          useBlocks = true,
        },
      },
    },
    init_options = {
      bundles = bundles,
    },
  }

  jdtls.start_or_attach(config)
end

return M
