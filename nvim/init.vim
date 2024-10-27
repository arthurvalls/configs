" General settings
set mouse=a
set signcolumn=no
set clipboard=unnamedplus
let g:coc_disable_startup_warning = 1
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
" set guicursor+=n:hor20-Cursor/lCursor
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20

" slide
nnoremap <C-w> :bnext<CR>
" remap esc
inoremap <C-C> <Esc>
vnoremap <C-C> <Esc>
cnoremap <C-C> <Esc>
set timeoutlen=500
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" List your plugins here
Plug 'tpope/vim-sensible'
Plug 'Mofiqul/vscode.nvim'
Plug 'sheerun/vim-polyglot' " Syntax highlighting
Plug 'projekt0n/github-nvim-theme'
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Auto-completion
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Plug 'jiangmiao/auto-pairs'
Plug 'rose-pine/neovim'
Plug 'xiyaowong/transparent.nvim'
Plug 'navarasu/onedark.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'} " Multiple cursors
Plug 'fatih/vim-go'
Plug 'charlespascoe/vim-go-syntax'
Plug 'vim-airline/vim-airline' " Status/tabline
Plug 'vim-airline/vim-airline-themes' " Airline themes
Plug 'dense-analysis/ale' " Asynchronous Lint Engine
Plug 'pangloss/vim-javascript' " JavaScript syntax highlighting
Plug 'github/copilot.vim'
Plug 'chaoren/vim-wordmotion'
Plug 'preservim/nerdcommenter'
Plug 'morhetz/gruvbox'
Plug 'preservim/nerdtree'
Plug 'craftzdog/solarized-osaka.nvim'
" Plug 'lambdalisue/vim-glyph-palette'
" always load this as the last one
Plug 'ryanoasis/vim-devicons'
call plug#end()

" Enable syntax highlighting
syntax on

" Show line numbers
set number
set relativenumber

" Auto-completion settings for coc.nvim
" Use <Tab> for trigger completion and navigate to the next complete item
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use <CR> to confirm completion
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Map Ctrl+A to move to the beginning of the line
nnoremap <C-A> ^
vnoremap <C-A> ^
inoremap <C-A> <C-O>^

" Map Ctrl+S to move to the end of the line
nnoremap <C-S> $
vnoremap <C-S> $
inoremap <C-S> <C-O>$

" Show file in status line
set laststatus=2
set statusline=%f

" Enable file type detection
filetype plugin indent on

" Additional options
set encoding=utf-8
set clipboard=unnamedplus " Use system clipboard
set hlsearch " Highlight search results
set incsearch " Incremental search

" Configure coc.nvim for Rust
let g:coc_global_extensions = ['coc-json', 'coc-tsserver', 'coc-rust-analyzer', 'coc-pyright', 'coc-eslint', 'coc-tslint', 'coc-tslint-plugin']


" fzf settings
" Optional: Use ripgrep if installed for faster searching
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git/"'
endif

" Define custom function for fzf search
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:' . reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction


" Custom command for fzf search
command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)
nnoremap <C-A-f> :Rg<CR>

" Keybindings for fzf
nnoremap <C-p> :Files<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <C-f> :Lines<CR>

" Initialize configuration dictionary
let g:fzf_vim = {}

" fzf layout settings
let g:fzf_layout = { 'down': '~40%' }

" Disable auto-pairs mapping of keys
" let g:auto_pairs_map_keys = 0
" let g:auto_pairs = {'(': ')', '{': '}', '[': ']'}

" vim-visual-multi settings
let g:VM_maps = {}
let g:VM_maps['Find Under'] = '<C-d>'
let g:VM_maps['Find Subword Under'] = '<C-d>'
let g:VM_maps["Exit"] = '<C-C>'   " quit VM

" vim-airline settings
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
let g:airline_powerline_fonts = 1
"let g:airline_section_a = ''
"let g:airline_section_b = ''
"let g:airline_section_c = '%f'

let g:airline_section_x = ''

let g:airline_section_y = ''
let g:airline_section_z = ''

" let g:airline_theme='base16_atelier_plateau'
" let g:airline_theme='luna'
let g:airline_theme='minimalist'

" ale settings
let g:ale_linters_explicit = 1
let g:ale_linters = {
\   'python': ['flake8', 'mypy'],
\   'javascript': ['eslint'],
\   'rust': ['cargo'],
\}
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier'],
\   'python': ['autopep8'],
\}
let g:ale_fix_on_save = 1

let g:NERDCompactSexyComs = 1

let g:NERDCommentEMptyLines = 1

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-x> <C-w>w
let g:NERDTreeFileLines = 1

" Enable NERDTree
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1

" Enable vim-devicons
let g:webdevicons_enable_nerdtree = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

colorscheme github_dark
