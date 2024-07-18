" General settings
set mouse=a
set signcolumn=no
set clipboard=unnamedplus
let g:coc_disable_startup_warning = 1
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
set guicursor+=n:hor20-Cursor/lCursor

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" List your plugins here
Plug 'tpope/vim-sensible'
Plug 'sheerun/vim-polyglot' " Syntax highlighting
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Auto-completion
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'mg979/vim-visual-multi', {'branch': 'master'} " Multiple cursors

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
let g:coc_global_extensions = ['coc-json', 'coc-tsserver', 'coc-rust-analyzer', 'coc-pyright']

" fzf settings
" Optional: Use ripgrep if installed for faster searching
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git/"'
endif

" Optional: Keybindings for fzf
nnoremap <C-p> :Files<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <C-f> :Rg<CR>
nnoremap <C-l> :BLines<CR>

" Disable auto-pairs mapping of keys
let g:auto_pairs_map_keys = 0
let g:auto_pairs = {'(': ')', '{': '}', '[': ']'}

" vim-visual-multi settings
let g:VM_maps = {}
let g:VM_maps['Find Under'] = '<C-d>'
let g:VM_maps['Find Subword Under'] = '<C-d>'
