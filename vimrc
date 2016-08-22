"necessary on some Linux distros for pathogen to properly load bundles
filetype on
filetype off

"load pathgen managed plugins
execute pathogen#infect()
Helptags

"Use Vim settings, rather then Vi settings (much better!).
"This must be first, because it changes other options as a side effect.
set nocompatible

"allow backspacing (removing) over everything in insert mode
set backspace=indent,eol,start

"store lots of :cmdline history
set history=1000

set showcmd     "show incomplete cmds down the bottom
set showmode    "show current mode down the bottom

set incsearch   "find the next match as we type the search
set hlsearch    "hilight searches by default

" remove search hilight
let hlstate=0
silent! nnoremap <silent> <Space> :if (hlstate%2 == 0) \| set nohlsearch \| else \| set hlsearch \| endif \| let hlstate=hlstate+1<CR>

set number      "add line numbers
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

"Git
set statusline+=%{fugitive#statusline()}

"RVM
set statusline+=%{exists('g:loaded_rvm')?rvm#statusline():''}

set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set laststatus=2

"turn off needless toolbar on gvim/mvim
set guioptions-=T
"turn off the scroll bar
set guioptions-=L
set guioptions-=r

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")
        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction


"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('^\t', 'nw') != 0
        let spaces = search('^ ', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")
        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)

    let long_line_lens = []

    let i = 1
    while i <= line("$")
        let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
        if len > threshold
            call add(long_line_lens, len)
        endif
        let i += 1
    endwhile

    return long_line_lens
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
    let nums = sort(a:nums)
    let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
endfunction

"indent settings
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent

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

"turn on syntax highlighting
syntax on

"some stuff to get the mouse going in term
set mouse=a
set ttymouse=xterm2

"hide buffers when not displayed
set hidden

"Activate smartcase
set ic
set smartcase

if has("gui_running")
    "tell the term has 256 colors
    set t_Co=256

    colorscheme solarized
    set guitablabel=%M%t
    set lines=40
    set columns=115

    if has("gui_gnome")
        set term=gnome-256color
        colorscheme molokai
        set guifont=Monospace\ Bold\ 11
    endif

    if has("gui_mac") || has("gui_macvim")
        set guifont=Menlo:h12
        set transparency=7
    endif

    if has("gui_win32") || has("gui_win32s")
        set guifont=Consolas:h12
        set enc=utf-8
    endif
else
    if $COLORTERM == 'gnome-terminal'
        " set term=gnome-256color
        set t_ut=
        colorscheme molokai
    else
        if $TERM == 'xterm-256color' || $TERM == 'xterm'
            set t_Co=256
            colorscheme molokai
            " set background=dark
            set t_ut=
        endif
        if $TERM == 'screen-256color' || $TERM == 'screen'
            set term=screen-256color
            colorscheme molokai
            " Disable Background Color Erase (BCE) so that color schemes
            " work properly when Vim is used inside tmux and GNU screen.
            " See also
            " http://snk.tuxfamily.org/log/vim-256color-bce.html
            set t_ut=
        else
            colorscheme default
        endif
    endif
endif

"visual search mappings
function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>


"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    end
endfunction

"define :HighlightLongLines command to highlight the offending parts of
"lines that are longer than the specified length (defaulting to 80)
command! -nargs=? HighlightLongLines call s:HighlightLongLines('<args>')
function! s:HighlightLongLines(width)
    let targetWidth = a:width != '' ? a:width : 79
    if targetWidth > 0
        exec 'match Todo /\%>' . (targetWidth) . 'v/'
    else
        echomsg "Usage: HighlightLongLines [natural number]"
    endif
endfunction

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

" NerdTree toggle button
silent! nmap <silent> <Leader>p :NERDTreeToggle<CR>

"map Q to something useful
noremap Q gq

"make Y consistent with C and D
nnoremap Y y$

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


"snipmate setup
source ~/.vim/snippets/support_functions.vim

autocmd vimenter * call s:SetupSnippets()

function! s:SetupSnippets()
    " call ExtractSnips("~/.vim/snippets/ruby", "ruby")
endfunction

" NERDTree settings
nmap wm :NERDTree<cr>
let NERDTreeIgnore=['\.swp$']

nnoremap <Esc>A <up>
nnoremap <Esc>B <down>
nnoremap <Esc>C <right>
nnoremap <Esc>D <left>
inoremap <Esc>A <up>
inoremap <Esc>B <down>
inoremap <Esc>C <right>
inoremap <Esc>D <left>

if has("balloon_eval")
    set noballooneval
endif

" open NerdTree on vim start
" autocmd vimenter * NERDTree

"Copy to clipboard
vmap <Space>c "+y
map <Space>v "+p

set fileencodings=utf-8

set backup
set backupdir=~/.tmp
set directory=~/.tmp

"set timeout between input macros
set timeout timeoutlen=500 ttimeoutlen=100

"set filetype for hamlc
au BufRead,BufNewFile *.hamlc set ft=haml
au BufRead,BufNewFile *.rtb set ft=ruby

"set filetype for rtb (prown gem)
au BufRead,BufNewFile *.rtb set ft=ruby

" Vroom config
let g:vroom_use_vimux=1

"enable spellchecker on git commit files
autocmd Filetype gitcommit setlocal spell textwidth=72

"set ctags default files
set tags=tags,./tags,gems.tags,./gems.tags

" Easy align plugin
vmap <Enter> <Plug>(EasyAlign)
nmap <Leader> <Plug>(EasyAlign)

" set colorscheme
colorscheme solarized
set background=dark

" Airline configuration
let g:airline_theme="solarized"
let g:airline_powerline_fonts=1
let g:airline#extensions#tmuxline#enabled = 1

" CTags
nnoremap <leader>. :CtrlPTag<cr>

" Max syntax
" set synmaxcol=120

" Disable syntastic javascript checker
let g:syntastic_javascript_checkers = ['eslint', 'tslint']

" Enable checker for Typescript
let g:syntastic_typescript_checkers = ['tslint']

" ES6 files
au BufRead,BufNewFile *.es6 set ft=javascript

" PostCSS with precss
au BufRead,BufNewFile *.css set ft=scss

" CtrlP
let g:ctrlp_custom_ignore = '\v[\/](node_modules|node_shrinkwrap)'

" Seeing is believing
augroup seeingIsBelievingSettings
    autocmd!

    autocmd FileType ruby nmap <buffer> <Enter>r <Plug>(seeing-is-believing-mark-and-run)
    autocmd FileType ruby xmap <buffer> <Enter>r <Plug>(seeing-is-believing-mark-and-run)

    autocmd FileType ruby nmap <buffer> <F4> <Plug>(seeing-is-believing-mark)
    autocmd FileType ruby xmap <buffer> <F4> <Plug>(seeing-is-believing-mark)
    autocmd FileType ruby imap <buffer> <F4> <Plug>(seeing-is-believing-mark)

    autocmd FileType ruby nmap <buffer> <F5> <Plug>(seeing-is-believing-run)
    autocmd FileType ruby imap <buffer> <F5> <Plug>(seeing-is-believing-run)
augroup END
