call plug#begin('~/.nvim/plugged')

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fugitive'
Plug 'slashmili/alchemist.vim'
Plug 'fatih/vim-go'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'neomake/neomake'
Plug 'mhinz/vim-grepper'
Plug 'chriskempson/base16-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-surround'
Plug 'othree/html5.vim'
Plug 'tomasr/molokai'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'zchee/deoplete-jedi'
Plug 'junegunn/vim-easy-align'
Plug 'elixir-lang/vim-elixir'
Plug 'vim-ruby/vim-ruby'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'benmills/vimux'
Plug 'othree/yajs.vim'
Plug 'skalnik/vim-vroom'
Plug 'kchmck/vim-coffee-script'
Plug 'chemzqm/vim-jsx-improve'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'Quramy/tsuquyomi'
Plug 'altercation/vim-colors-solarized'
Plug 'fleischie/vim-styled-components'

call plug#end()

" Basic setup
set nocompatible
set number
set showbreak=...
set wrap linebreak nolist

" disable arrow keys
map <Down> <Nop>
map <Up> <Nop>
map <Left> <Nop>
map <Right> <Nop>

"add some line space for easy reading
set linespace=4

"disable visual bell
set visualbell t_vb=

"statusline setup
set statusline=%f       "tail of the filename

" color scheme
if filereadable(expand("~/.vimrc_background"))
  source ~/.vimrc_background
endif
" let base16colorspace=256
colorscheme solarized
set background=dark

"indent settings
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent

"Activate smartcase
set ic
set smartcase

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

set wildmode=list:longest   "make cmdline tab completion similar to bash
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing

set formatoptions-=o "dont continue comments when pushing o/O

"vertical/horizontal scroll off settings
set scrolloff=3
set sidescrolloff=7
set sidescroll=1

"load ftplugins and indent files
filetype plugin on
filetype indent on

"syntax on
syntax on

" Strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" NerdTree
nmap wm :NERDTree<cr>
let NERDTreeIgnore=['\.swp$']
silent! nmap <silent> <Leader>p :NERDTreeToggle<CR>
autocmd vimenter * NERDTree
nnoremap <Esc>A <up>
nnoremap <Esc>B <down>
nnoremap <Esc>C <right>
nnoremap <Esc>D <left>
inoremap <Esc>A <up>
inoremap <Esc>B <down>
inoremap <Esc>C <right>
inoremap <Esc>D <left>

" Deoplete
let g:deoplete#enable_at_startup = 1
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"Copy to clipboard
set clipboard=unnamed

"file enconding
set fileencodings=utf-8

"neomake
autocmd! BufWritePost * Neomake
let g:typescript_compiler_binary = ''

" Airline configuration
let g:airline_theme="base16"
let g:airline_powerline_fonts=1
let g:airline#extensions#tmuxline#enabled = 1

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*

"key mapping for vimgrep result navigation
map <A-o> :copen<CR>
map <A-q> :cclose<CR>
map <A-j> :cnext<CR>
map <A-k> :cprevious<CR>

"key mapping for window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

"key mapping for saving file
nmap <C-s> :w<CR>

"key mapping for tab navigation
nmap <S-Tab> gt
nmap <C-S-Tab> gT

"Key mapping for textmate-like indentation
nmap <D-[> <<
nmap <D-]> >>
vmap <D-[> <gv
vmap <D-]> >gv

"map Q to something useful
noremap Q gq

"make Y consistent with C and D
nnoremap Y y$

"set timeout between input macros
set spell
set spelllang=en_us
set spellfile=$HOME/.spell/en.utf-8.add
set complete+=kspell
set timeout timeoutlen=500 ttimeoutlen=100

"enable spellchecker on git commit files
au FileType gitcommit set tw=72

if exists("+undofile")
    " undofile - This allows you to use undos after exiting and restarting
    " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
    " :help undo-persistence
    " This is only present in 7.3+
    if isdirectory($HOME . '/.vim/undo') == 0
        :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
    endif
    set undodir=./.vim-undo//
    set undodir+=~/.vim/undo//
    set undofile
endif

if has('nvim')
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
  " Hack to get C-h working in neovim
  nmap <BS> <C-W>h
  tnoremap <Esc> <C-\><C-n>
endif

"CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" EasyAlign
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Vroom config
let g:vroom_use_vimux=1

map <C-q> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Indent-guides
let g:indent_guides_auto_colors = 0
let g:indentguides_start_level=1
hi IndentGuidesOdd  ctermbg=black
hi IndentGuidesEven ctermbg=darkgrey
