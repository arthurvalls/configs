# Neovim Plugins Reference

## Core & Plugin Management

| Plugin | Description |
|--------|-------------|
| **lazy.nvim** | Plugin manager with lazy loading, profiling, and lockfile support |

## Completion & Snippets

| Plugin | Description |
|--------|-------------|
| **blink.cmp** | Fast completion engine (replaced nvim-cmp). Built-in snippet support, fuzzy matching with typo tolerance |
| **blink-copilot** | Bridges GitHub Copilot suggestions into blink.cmp completion menu |
| **copilot.lua** | GitHub Copilot backend (inline suggestions disabled, flows through blink.cmp) |
| **friendly-snippets** | Collection of premade snippets for many languages |
| **lazydev.nvim** | Lua/Neovim API completion and type checking for plugin development |

### Completion Keymaps

| Key | Action |
|-----|--------|
| `<CR>` | Accept completion |
| `<Tab>` / `<S-Tab>` | Navigate next/prev item |
| `<C-Space>` | Trigger completion manually |
| `<C-b>` / `<C-f>` | Scroll documentation up/down |
| `<C-l>` / `<C-h>` | Jump forward/backward in snippet |

## LSP & Language Support

| Plugin | Description |
|--------|-------------|
| **nvim-lspconfig** | LSP client configurations for clangd, pyright, rust_analyzer, jdtls, ts_ls, lua_ls |
| **mason.nvim** | LSP/DAP/linter/formatter installer and manager |
| **nvim-java** | Enhanced Java support |

### LSP Keymaps

| Key | Action |
|-----|--------|
| `grd` | Go to definition |
| `grr` | Find references |
| `gri` | Go to implementation |
| `grt` | Go to type definition |
| `grn` | Rename symbol |
| `gra` | Code action |
| `gO` | Document symbols |
| `gW` | Workspace symbols |

## Navigation

| Plugin | Description |
|--------|-------------|
| **telescope.nvim** | Fuzzy finder for files, grep, LSP symbols, buffers, and more |
| **flash.nvim** | Jump anywhere on screen by typing 2 characters. Integrates with `/` search and treesitter |
| **neo-tree** | File explorer sidebar |
| **oil.nvim** | Edit filesystem like a buffer (rename by editing text, create by typing new lines) |

### Navigation Keymaps

| Key | Action |
|-----|--------|
| `s` | Flash jump (type 2 chars, press label) |
| `S` | Flash treesitter select (select code nodes) |
| `-` | Open parent directory in Oil (floating window) |
| `]]` / `[[` | Jump to next/prev LSP reference of word under cursor |
| `<C-a>` / `<C-s>` | Go to beginning/end of line |

### Telescope Keymaps (`<leader>s`)

| Key | Action |
|-----|--------|
| `<leader>sf` | Search files |
| `<leader>sg` | Live grep |
| `<leader>sw` | Search word under cursor |
| `<leader>sd` | Search diagnostics |
| `<leader>sh` | Search help |
| `<leader>sk` | Search keymaps |
| `<leader>sn` | Search Neovim config files |
| `<leader><leader>` | Switch buffers |

## Buffers

| Plugin | Description |
|--------|-------------|
| **bufferline.nvim** | VS Code-style tab bar showing open buffers with LSP diagnostics, pin support |

### Buffer Keymaps (`<leader>b`)

| Key | Action |
|-----|--------|
| `<S-h>` / `<S-l>` | Cycle prev/next buffer |
| `<leader>bd` | Close current buffer (keeps window open) |
| `<leader>bo` | Close all other buffers |
| `<leader>bp` | Pin buffer |
| `<leader>bP` | Close non-pinned buffers |
| `<leader>br` / `<leader>bl` | Close buffers to right/left |

## Diagnostics & Code Intelligence

| Plugin | Description |
|--------|-------------|
| **trouble.nvim** | Pretty list for diagnostics, references, quickfix, TODOs, and symbols |
| **todo-comments.nvim** | Highlights TODO/FIXME/HACK/NOTE comments across the project |

### Trouble Keymaps (`<leader>x`)

| Key | Action |
|-----|--------|
| `<leader>xx` | All diagnostics |
| `<leader>xX` | Buffer diagnostics only |
| `<leader>xs` | Symbol outline |
| `<leader>xl` | LSP definitions/references panel |
| `<leader>xL` | Location list |
| `<leader>xQ` | Quickfix list |
| `<leader>xt` | All TODOs across project |

Inside Trouble window: `<CR>` to jump, `j`/`k` to navigate, `o` to jump and close, `q` to close.

## Git

| Plugin | Description |
|--------|-------------|
| **gitsigns.nvim** | Git signs in gutter (added/modified/deleted lines), hunk operations, inline blame |
| **snacks.lazygit** | Full lazygit TUI inside Neovim (requires `lazygit` installed) |
| **snacks.gitbrowse** | Open current file/line in GitHub/GitLab |

### Git Keymaps

| Key | Action |
|-----|--------|
| `<leader>gg` | Open Lazygit |
| `<leader>gl` | Lazygit log (cwd) |
| `<leader>gf` | Lazygit log (current file) |
| `]c` / `[c` | Jump to next/prev git hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage buffer |
| `<leader>hR` | Reset buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame current line (one-shot) |
| `<leader>hd` | Diff against index |
| `<leader>hD` | Diff against last commit |
| `<leader>tb` | Toggle persistent inline blame (all lines) |
| `<leader>tD` | Toggle inline deleted lines |

## UI & Visuals

| Plugin | Description |
|--------|-------------|
| **lualine.nvim** | Statusline with mode, branch, diagnostics, filename, diff stats, progress |
| **dropbar.nvim** | IDE-like breadcrumbs in winbar (file > class > function). Clickable |
| **noice.nvim** | Enhanced LSP hover/signature UI |
| **nvim-web-devicons** | File type icons |
| **dashboard-nvim** | Start screen with file finder shortcuts |
| **which-key.nvim** | Shows available keybindings when you press `<leader>` and pause |
| **smear-cursor** | Animated cursor movement |
| **neoscroll.nvim** | Smooth scrolling for `<C-u>`, `<C-d>`, `<C-b>`, `<C-f>`, `zt`, `zz`, `zb` |
| **rainbow-delimiters.nvim** | Rainbow-colored brackets by nesting depth |
| **nvim-highlight-colors** | Inline color preview for hex/RGB/HSL/Tailwind values |
| **snacks.indent** | Animated indent guides with scope highlighting (replaced indent-blankline) |
| **snacks.dim** | Dims inactive code scopes |
| **snacks.statuscolumn** | Enhanced sign/number column |

## Editing

| Plugin | Description |
|--------|-------------|
| **mini.ai** | Better around/inside textobjects (`va)`, `ci'`, `yinq`) |
| **mini.surround** | Add/delete/replace surroundings (`gsa`, `gsd`, `gsr`) |
| **nvim-autopairs** | Auto-close brackets, quotes, etc. |
| **vim-sleuth** | Auto-detect indentation settings |
| **nvim-treesitter** | Syntax highlighting and code understanding |

## Formatting & Linting

| Plugin | Description |
|--------|-------------|
| **conform.nvim** | Code formatting on save (stylua, black, prettier, eslint_d) |
| **nvim-lint** | Async linting (eslint_d for JS/TS, markdownlint) |
| **stylua** | Lua formatter |

| Key | Action |
|-----|--------|
| `<leader>f` | Format current buffer |

## Testing & Debugging

| Plugin | Description |
|--------|-------------|
| **nvim-dap** | Debug Adapter Protocol client |
| **dap-ui** | Debugger UI with watches, breakpoints, stack trace |
| **neotest** | Test runner framework |
| **neotest-java** | Java test adapter for neotest |

## Utilities

| Plugin | Description |
|--------|-------------|
| **snacks.nvim** | Modular QoL suite by folke (notifier, indent, terminal, zen, scratch, lazygit, bigfile, quickfile, words, dim, profiler, toggle, scope, statuscolumn, gitbrowse) |
| **undotree** | Visualize and navigate Neovim's branching undo history |
| **persistence.nvim** | Auto-saves and restores sessions per project directory |
| **vim-dadbod** | Database client with UI and completion |
| **leetcode.nvim** | LeetCode integration |

### Utility Keymaps

| Key | Action |
|-----|--------|
| `<leader>z` | Toggle Zen mode (distraction-free editing) |
| `<leader>u` | Toggle undo tree |
| `<leader>.` | Toggle scratch buffer |
| `<leader>S` | Select from scratch buffers |
| `<leader>un` | Dismiss all notifications |
| `<c-/>` | Toggle floating terminal |

### Session Keymaps (`<leader>q`)

| Key | Action |
|-----|--------|
| `<leader>qs` | Restore session for current directory |
| `<leader>ql` | Restore last session |
| `<leader>qS` | Pick from saved sessions |
| `<leader>qd` | Stop saving current session |

## Replaced Plugins

| Old | New | Why |
|-----|-----|-----|
| nvim-cmp + LuaSnip | blink.cmp | Faster completion, simpler config, built-in snippets and fuzzy matching |
| nvim-notify | snacks.notifier | Better integration with snacks ecosystem |
| indent-blankline | snacks.indent | Animated indent guides with scope highlighting |
| mini.statusline | lualine.nvim | More customizable with diagnostics, diff, branch, and extensions |
