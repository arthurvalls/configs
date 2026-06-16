-- ~/.config/nvim/lua/jdtls_setup.lua
-- Driven by ftplugin/java.lua (runs once per java buffer; start_or_attach is
-- idempotent and reuses one client per reactor root).
local M = {}

-- jdtls itself must run on a JDK 17+. Projects can target anything via the
-- `runtimes` table below.
local JAVA_BIN = "/usr/lib/jvm/java-21-openjdk-amd64/bin/java"
local JAVA_21_HOME = "/usr/lib/jvm/java-21-openjdk-amd64"

-- Find the OUTERMOST project root so a multi-module Maven reactor is imported as
-- a whole. SuperSim repos are one reactor per git repo, so the git root is the
-- reactor root. Picking a submodule's pom.xml here is exactly what caused jdtls
-- to only resolve one module's classpath ("doesn't grab all libs").
local function find_reactor_root(bufname)
  local git_root = vim.fs.root(bufname, { ".git" })
  if git_root then
    return git_root
  end
  -- Fallback: outermost pom.xml / build.gradle walking upward.
  local build_files = vim.fs.find(
    { "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle", "settings.gradle.kts" },
    { path = bufname, upward = true, limit = math.huge }
  )
  if #build_files > 0 then
    return vim.fs.dirname(build_files[#build_files]) -- last match = highest dir
  end
  return vim.fn.getcwd()
end

function M.setup()
  local jdtls = require("jdtls")
  local home = os.getenv("HOME")

  -- Use the Mason-managed jdtls (the old ~/jdtls path never existed here).
  local jdtls_install = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
  local launcher_jar = vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  if launcher_jar == "" then
    vim.notify("jdtls launcher jar not found in " .. jdtls_install .. " — run :Mason and install jdtls", vim.log.levels.ERROR)
    return
  end

  local root_dir = find_reactor_root(vim.api.nvim_buf_get_name(0))

  -- Per-project, PERSISTENT workspace keyed on the reactor root. This is what
  -- stops a full re-index on every launch (the main cause of the indexing lag).
  local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
  local workspace_folder = home .. "/.cache/jdtls-workspace/" .. project_name
  vim.fn.mkdir(workspace_folder, "p")

  -- Bundles: java-debug-adapter (DAP) + vscode-java-test (neotest-java).
  local bundles = {}
  local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
  vim.list_extend(
    bundles,
    vim.fn.glob(mason_path .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true, true)
  )
  vim.list_extend(
    bundles,
    vim.split(vim.fn.glob(mason_path .. "/java-test/extension/server/*.jar", true), "\n", { trimempty = true })
  )

  -- Tell the server about nvim-jdtls' extra capabilities (full classpath
  -- resolution, hashCodeEquals, etc.) and feed it nvim-cmp/blink capabilities.
  local capabilities = require("blink.cmp").get_lsp_capabilities()
  local extended = vim.tbl_deep_extend("force", {}, jdtls.extendedClientCapabilities)
  extended.resolveAdditionalTextEditsSupport = true

  local config = {
    cmd = {
      JAVA_BIN,
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xms1g",
      "-Xmx6g", -- heavy multi-module reactors need headroom; default was the GC-thrash cause
      "-XX:+UseG1GC",
      "-XX:+UseStringDeduplication",
      "--add-modules=ALL-SYSTEM",
      "--add-opens", "java.base/java.util=ALL-UNNAMED",
      "--add-opens", "java.base/java.lang=ALL-UNNAMED",
      "-jar", launcher_jar,
      "-configuration", jdtls_install .. "/config_linux",
      "-data", workspace_folder,
    },
    root_dir = root_dir,
    capabilities = capabilities,
    init_options = {
      bundles = bundles,
      extendedClientCapabilities = extended,
    },
    settings = {
      java = {
        -- Resolve library + JDK sources so go-to-definition lands in real code,
        -- with a decompiler fallback for anything without sources.
        eclipse = { downloadSources = true },
        maven = { downloadSources = true },
        references = { includeDecompiledSources = true },
        -- Re-import automatically when a pom.xml changes (no prompt).
        configuration = {
          updateBuildConfiguration = "automatic",
          runtimes = {
            { name = "JavaSE-21", path = JAVA_21_HOME, default = true },
          },
        },
        import = {
          maven = { enabled = true },
          gradle = { enabled = true },
        },
        -- CodeLens scans the whole reactor for refs/impls on every file — pure
        -- overhead for this workflow, disable it.
        implementationsCodeLens = { enabled = false },
        referencesCodeLens = { enabled = false },
        signatureHelp = { enabled = true },
        contentProvider = { preferred = "fernflower" },
        format = {
          enabled = true,
          settings = {
            url = vim.fn.stdpath("config") .. "/java-formatter.xml",
            profile = "GoogleStyle",
          },
        },
        completion = {
          favoriteStaticMembers = {
            "org.junit.jupiter.api.Assertions.*",
            "org.junit.jupiter.api.Assumptions.*",
            "org.junit.jupiter.api.DynamicContainer.*",
            "org.junit.jupiter.api.DynamicTest.*",
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
    on_attach = function(_, _)
      -- Wire jdtls into nvim-dap (test/main-class debugging via neotest-java).
      require("jdtls").setup_dap({ hotcodereplace = "auto" })
    end,
  }

  jdtls.start_or_attach(config)
end

return M
