# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration based on kickstart.nvim, extended with additional plugins and customizations. The configuration uses lazy.nvim as the plugin manager and follows a modular structure separating core options, keymaps, and plugin configurations.

## Architecture

### Directory Structure

- `init.lua` - Main entry point that bootstraps lazy.nvim and loads configuration modules
- `lua/config/` - Core configuration modules
  - `options.lua` - Vim options (leader key, display settings, indentation)
  - `keymaps.lua` - Custom keymaps and autocommands
  - `plugins.lua` - Plugin specification loader
  - `plugins/` - Individual plugin configurations (50+ files)
- `lua/kickstart/plugins/` - Standard kickstart.nvim plugin configurations
- `lua/jdtls_setup.lua` - Java LSP (JDTLS) configuration
- `lua/custom/` - Custom user modules
- `coc-settings.json` - CoC (Conquer of Completion) settings (legacy, may not be actively used)
- `java-formatter.xml` - Java code formatting rules (Google Style)

### Plugin Management

The configuration uses lazy.nvim with a modular approach:
- Each plugin is configured in its own file under `lua/config/plugins/`
- Plugin specifications are loaded via `lua/config/plugins.lua`
- Plugins are loaded lazily based on events, commands, or filetypes

### Key Plugin Categories

**LSP & Completion:**
- `nvim-lspconfig` with Mason for LSP server management
- Configured servers: clangd, pyright, rust_analyzer, jdtls, ts_ls, lua_ls
- `nvim-cmp` for autocompletion with LuaSnip snippets
- `nvim-java` for enhanced Java support

**Testing & Debugging:**
- `nvim-dap` for debugging with DAP UI and virtual text
- `neotest` with `neotest-java` for running tests
- `vim-test` for test runner integration

**UI & Navigation:**
- `telescope.nvim` for fuzzy finding (files, grep, LSP symbols, etc.)
- `neo-tree` for file explorer
- `which-key` for keymap hints
- `gitsigns` for git integration
- `noice.nvim` for enhanced UI
- `dashboard` for start screen

**Editing:**
- `nvim-treesitter` for syntax highlighting and code understanding
- `conform.nvim` for code formatting (stylua, black, prettier, eslint_d)
- `mini.nvim` for various editing enhancements
- `autopairs` for auto-closing brackets/quotes

**Themes:**
- Multiple color schemes available (iceberg is currently active)
- Others: gruvbox, tokyo, darcula, base16, tinted, lackluster

## Common Development Tasks

### LSP Operations

Key LSP keymaps (all prefixed with `gr`):
- `grd` - Go to definition
- `grr` - Find references
- `gri` - Go to implementation
- `grt` - Go to type definition
- `grn` - Rename symbol
- `gra` - Code action
- `gO` - Document symbols
- `gW` - Workspace symbols

### Telescope Keymaps

All telescope keymaps use `<leader>s` prefix:
- `<leader>sf` - Search files
- `<leader>sg` - Live grep
- `<leader>sw` - Search word under cursor
- `<leader>sd` - Search diagnostics
- `<leader>sh` - Search help
- `<leader>sk` - Search keymaps
- `<leader>sn` - Search Neovim config files
- `<leader><leader>` - Switch buffers

### Code Formatting

- Format current buffer: `<leader>f`
- Format on save is enabled for most filetypes (except Java by default)
- Formatters by language:
  - Lua: stylua
  - Python: black
  - JavaScript/TypeScript: prettierd or prettier
  - React: eslint_d + prettierd

### Java Development

Java uses a specialized setup:
- JDTLS (Java LSP) is configured via `lua/jdtls_setup.lua`
- Java formatter uses Google Style (configured in `java-formatter.xml`)
- JDTLS installation expected at `~/jdtls/`
- Workspace stored at `~/.cache/jdtls-workspace/`
- Java runtime configured for Java 21 at `/usr/lib/jvm/default-java/`

To work with Java files:
- JDTLS will auto-start when opening `.java` files
- Neotest can run individual tests or test classes
- DAP is configured for Java debugging

### Navigation Keymaps

Custom movement keymaps:
- `<C-a>` / `<C-s>` - Go to beginning/end of line
- `q` / `Q` - Move backward by word (overrides default `q` for macros)
- `<C-h/j/k/l>` - Navigate between windows

### Managing Plugins

- `:Lazy` - Open lazy.nvim UI to view/update plugins
- `:Mason` - Open Mason UI to install/update LSP servers and tools
- `:ConformInfo` - View formatter configuration and status

### Configuration Changes

When modifying this configuration:
1. Edit files in `lua/config/` for options, keymaps, or plugin list
2. Add new plugin configs in `lua/config/plugins/` as separate files
3. Reference new plugin configs in `lua/config/plugins.lua`
4. Restart Neovim or use `:Lazy reload <plugin>` for changes to take effect

## Important Settings

- Leader key: `<Space>`
- Tab width: 4 spaces (expandtab enabled)
- Line numbers enabled (relative numbers disabled)
- Color column at 80 characters
- Clipboard integrated with system clipboard (`unnamedplus`)
- Persistent undo enabled
- LSP logging disabled for performance

## External Dependencies

Required system tools:
- `git`, `make`, `gcc` (build essentials)
- `ripgrep` (for telescope grep)
- `fd` (optional, for telescope file finding)
- Clipboard tool: `xclip` or `xsel` (Linux)
- Nerd Font (configured with `vim.g.have_nerd_font = true`)

Language-specific tools:
- Node.js/npm (for TypeScript/JavaScript LSPs and formatters)
- Python with `black` formatter
- Rust with `rust-analyzer`
- Java 21+ with JDTLS installation
- `stylua` for Lua formatting (auto-installed via Mason)
