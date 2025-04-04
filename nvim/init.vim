" =============================================================================
" General Settings
" =============================================================================
set mouse=a             " Enable mouse support
set signcolumn=yes      " Reserve space for signs (diagnostic indicators)
set encoding=utf-8      " Set default encoding to UTF-8
set clipboard=unnamedplus " Use system clipboard
set hlsearch            " Highlight search results
set incsearch           " Incremental search
set number              " Show line numbers
set relativenumber      " Show relative line numbers
set laststatus=2        " Always show the status line
" set termguicolors       " Enable true color support for themes
set updatetime=300      " Faster update time for better UX
set shortmess+=c        " Don't pass messages to |ins-completion-menu|

" Persistent Undo
set undofile            " Save undo history to file
set undodir=~/.config/nvim/undodir " Directory to store undo files

" Make sure the undo directory exists
if !isdirectory(&undodir)
  call mkdir(&undodir, "p", 0700)
endif

" Cursor shape
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20

" Enable file type detection, plugins, and indentation
filetype plugin indent on

" Enable syntax highlighting
syntax on

" Automatically reload files when they are changed externally
set autoread
au FocusGained,BufEnter * :checktime

" =============================================================================
" Key Mappings (User Defined - Kept as requested)
" =============================================================================
" Replace in visual mode
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" Remap q (overrides default macro recording start)
nnoremap q b
nnoremap Q B
vnoremap q b
vnoremap Q B

" Remap Esc
inoremap <C-C> <Esc>
vnoremap <C-C> <Esc>
cnoremap <C-C> <Esc>

" Map Ctrl+A to move to the beginning of the line (overrides default increment)
nnoremap <C-A> ^
vnoremap <C-A> ^
inoremap <C-A> <C-O>^

" Map Ctrl+S to move to the end of the line (overrides default XOFF)
nnoremap <C-S> $
vnoremap <C-S> $
inoremap <C-S> <C-O>$

" Map Ctrl+X to switch window (overrides default Ctrl+X mode)
nnoremap <C-x> <C-w>w

" =============================================================================
" Plugin Management: vim-plug
" =============================================================================
" Specify a directory for plugins (Neovim standard path)
call plug#begin('~/.local/share/nvim/plugged')

" Sensible defaults
Plug 'tpope/vim-sensible'

" Themes
Plug 'Mofiqul/vscode.nvim'
Plug 'projekt0n/github-nvim-theme'
Plug 'rose-pine/neovim'
Plug 'morhetz/gruvbox'

" UI / Utility
Plug 'xiyaowong/transparent.nvim'
Plug 'vim-airline/vim-airline' " Status/tabline
Plug 'vim-airline/vim-airline-themes' " Airline themes
Plug 'preservim/nerdtree' " File explorer
Plug 'tiagofumo/vim-nerdtree-syntax-highlight' " NERDTree icons theme
Plug 'ryanoasis/vim-devicons' " File icons (Requires patched font)
Plug 'lambdalisue/vim-glyph-palette' " Icon helper

" Fuzzy Finding
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Core fzf
Plug 'junegunn/fzf.vim' " Vim integration for fzf

" Completion / LSP / Linting / Formatting
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Auto-completion framework
Plug 'github/copilot.vim' " AI code assistant

" Language Specific & Syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " Modern syntax engine
Plug 'pangloss/vim-javascript' " JavaScript syntax highlighting
Plug 'fatih/vim-go' " Go development plugin suite

" Editing Enhancements
Plug 'mg979/vim-visual-multi', {'branch': 'master'} " Multiple cursors
Plug 'chaoren/vim-wordmotion' " Improved word motions
Plug 'preservim/nerdcommenter' " Easy code commenting
Plug 'tpope/vim-surround' " Surround text objects

" Git
Plug 'f-person/git-blame.nvim'
Plug 'tpope/vim-fugitive' " Git commands

" Dependencies
Plug 'nvim-lua/plenary.nvim' " Required by some Lua plugins

" Java specific
Plug 'mfussenegger/nvim-dap' " Debug Adapter Protocol client
Plug 'rcarriga/nvim-dap-ui' " UI for nvim-dap

call plug#end()

" =============================================================================
" Plugin Configuration
" =============================================================================

" --- Theme Configuration ---
set notermguicolors
" --- Coc (Completion) ---
" Use <Tab> for trigger completion and navigate next, <S-Tab> for previous
inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : CheckBackspace() ? "\<Tab>" : coc#refresh()
inoremap <silent><expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Use <CR> to confirm completion
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Apply code action to the selected region
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Apply code action to the current buffer
nmap <leader>ac  <Plug>(coc-codeaction)

" Apply quickfix action to the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Global extensions for Coc
let g:coc_global_extensions = [
\  'coc-json',
\  'coc-tsserver',
\  'coc-rust-analyzer',
\  'coc-pyright',
\  'coc-eslint',
\  'coc-java',
\  'coc-prettier'
\ ]

" Format Java files with CoC on save
command! -nargs=0 Format :call CocAction('format')
autocmd FileType java nnoremap <buffer> <leader>f :Format<CR>

" --- Treesitter Configuration ---
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "java", "kotlin", "javascript", "typescript",
    "python", "rust", "go", "lua", "vim", "json", "html", "css"
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  }
}
EOF

" --- FZF (Fuzzy Finder) ---
" Use ripgrep if available for faster searching
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git/" --glob "!node_modules/"'
endif

" Custom function for fzf search using ripgrep
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a.query, '--bind', 'change:reload:' . reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a.fullscreen)
endfunction

" Custom command for fzf search
command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

" Keybindings for fzf (User Defined - Kept as is)
nnoremap <C-A-f> :Rg<CR>
nnoremap <C-p> :Files<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <C-f> :Lines<CR>
" Initialize configuration dictionary
let g:fzf_vim = {}

" fzf layout settings
let g:fzf_layout = { 'down': '~40%' }

" --- vim-visual-multi ---
let g:VM_maps = {}
let g:VM_maps['Find Under'] = '<C-d>'
let g:VM_maps['Find Subword Under'] = '<C-d>'
let g:VM_maps["Exit"] = '<C-C>'   " quit VM

" --- vim-airline ---
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#default#section_truncate_width = {
\   'b': 40,
\   'x': 40,
\   'y': 40,
\   'z': 40,
\}
let g:airline#extensions#default#layout = [
\ [ 'a', 'b', 'c' ],
\ [ 'z' ]
\]
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#left = [ ]
let g:airline#extensions#tabline#right = [ ]
let g:airline_powerline_fonts = 1 " Use powerline symbols (requires patched font)
let g:airline_section_x = ''
let g:airline_section_y = ''
let g:airline_section_z = ''
let g:airline_theme = 'minimalist' " Set your preferred theme

" --- NERDCommenter ---
let g:NERDCompactSexyComs = 1 " Use compact comment delimiters
let g:NERDCommentEmptyLines = 1 " Comment/uncomment empty lines

" --- NERDTree ---
nnoremap <leader>n :NERDTreeFocus<CR> " Use <leader>n to focus NERDTree
nnoremap <C-t> :NERDTreeToggle<CR> " Use Ctrl+t to toggle NERDTree

let g:NERDTreeFileLines = 1 " Show file lines (experimental)
let NERDTreeShowHidden = 1 " Show hidden files
let NERDTreeMinimalUI = 1 " Use minimal UI

" --- vim-devicons ---
let g:webdevicons_enable_nerdtree = 1 " Enable icons in NERDTree
let g:NERDTreeDirArrowExpandable = '▸' " Use nice arrows (requires patched font)
let g:NERDTreeDirArrowCollapsible = '▾'

" --- Java Specific Commands ---
" Common Java operations
augroup java_commands
  autocmd!
  " Java-specific mappings
  autocmd FileType java nnoremap <leader>o :CocCommand java.action.organizeImports<CR>
  autocmd FileType java nnoremap <leader>jc :CocCommand java.clean.workspace<CR>
  autocmd FileType java nnoremap <leader>jt :CocCommand java.test.generateTests<CR>
  autocmd FileType java nnoremap <leader>jg :CocCommand java.project.generateToWorkspace<CR>
  autocmd FileType java nnoremap <leader>jr :CocCommand java.action.rename<CR>

augroup END
