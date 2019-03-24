if empty(glob(expand('~/.vim/autoload/plug.vim')))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

  "silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs

call plug#begin(expand('~/.vim/bundle'))
Plug 'kien/rainbow_parentheses.vim'
Plug 'mxw/vim-jsx'
Plug 'nelstrom/vim-markdown-folding'
Plug 'pangloss/vim-javascript'
" Plug 'udalov/kotlin-vim'
Plug 'jceb/vim-orgmode'
Plug 'vim-scripts/SyntaxRange'
Plug 'vim-scripts/narrow_region'
Plug 'tpope/vim-speeddating'
Plug 'rking/ag.vim'
Plug 'tomasr/molokai'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-syntastic/syntastic'
" Initialize plugin system
call plug#end()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Tsao's Configuration
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible                " incompatibility with vi to enable the awesome of vim
syntax enable                   " how is this not a default?
set encoding=utf-8              " we are the world
set showcmd                     " display incomplete commands
let mapleader=","               " cargo-culted but I like it
let g:mapleader = ","           " ditto
"call pathogen#infect()       " manage plugins via /bundle with pathogen
"call pathogen#helptags()     "
filetype plugin indent on       " load file type plugins + indentation
set path=**                     " Starting with current path, search recursively
set scrolloff=3                 " Show 3 lines of context around the cursor.

" Make sure syntax highlighting doesn't go all cracky
autocmd BufEnter * :syntax sync fromstart
set synmaxcol=128               " Don't try to highlight long lines

"" Whitespace
" set wrap linebreak nolist     " wrap lines on words, not characters
set nowrap linebreak nolist     " wrap lines on words, not characters
set tabstop=2 shiftwidth=2      " a tab is two spaces
set expandtab                   " use spaces, not tabs
set backspace=indent,eol,start  " backspace through everything in insert mode
set autoindent
set copyindent

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

set directory=/tmp              " write swap files in /tmp
set ruler                       " show the cursor position all the time
set list listchars=trail:.,tab:>. " highlight trailing whitespace, etc.

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

" Wide gutter so that numbers line up nicely
set numberwidth=5

set laststatus=2                                " always show the status line, even if only one split is visible.
set showmatch                                   " show matching brackets
set undofile                                    " tells vim to create undofiles. awesome!
set cursorline
set autoread

set wildmenu
set wildignore=*.o,*.obj,*.bak,*.exe,*.py[co],*.swp,*~,*.pyc,.svn,*.bzr


" No bell!
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filetypes
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au BufNewFile,BufRead *.txt  setlocal filetype=markdown
au BufNewFile,BufRead *.jsx  setlocal filetype=javascript
au BufNewFile,BufRead *.mjs  setlocal filetype=javascript

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keyboard Goodness
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" handcuffs for arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" no help when i mean escape
nnoremap <F1> <Esc>
inoremap <F1> <Esc>
vnoremap <F1> <Esc>

" and, let's get out of insert a little easier
" inoremap JK <Esc>
" inoremap KJ <Esc>
" inoremap jk <Esc>
" inoremap kj <Esc>

" i sorta like this. but it messes up my line movements..
" nnoremap <C-j> gj
" nnoremap <C-k> gk

" emacs keybindings in command line
cnoremap <C-a>  <Home>
cnoremap <C-b>  <Left>
cnoremap <C-f>  <Right>
cnoremap <C-d>  <Delete>
cnoremap <M-b>  <S-Left>
cnoremap <M-f>  <S-Right>
cnoremap <M-d>  <S-Right><Delete>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>
cnoremap <Esc>d <S-right><Delete>
cnoremap <C-g>  <C-c>

" emacs keybindings in insert mode
inoremap <C-b> <Left>
inoremap <C-f> <Right>
" this version no-worky
" inoremap <M-f> <S-Right>
" this no worky either
" inoremap <M-f> <CTRL-O>w
inoremap <M-b> <S-Left>
inoremap <C-a> <Home>
inoremap <C-e> <End>

" clear the search buffer
nnoremap <leader><space> :noh<cr>
"
" delete without yanking
" nnoremap <leader>d "_d
" vnoremap <leader>d "_d

" replace currently selected text with default register
" without yanking it
" vnoremap <leader>p "_dP

" Create headers in Markdown docs."
" this is because I use this all the damn time
" It will duplicate a line and replace all the chars with `=`
nnoremap <leader>= yypVr=o<cr>

" duplicating textmate/sublime's duplicate line
" nnoremap <D-D> yyp<cr>
" vnoremap <D-D> yP<cr>

" save via sudo
cmap w!! w !sudo tee % >/dev/null

" Shortcut to rapidly toggle show/hide invisible chars (`set list`)
nmap <leader>i :set list!<CR>

" shortcut for making current working directory the same as current file
nmap <silent> <leader>cd :cd %:p:h<CR>:pwd<CR>

" insert the current timestamp
iab <expr> now` strftime("%c")


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:solarized_termcolors=256
"set background=dark  "dark|light
if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://sunaku.github.io/vim-256color-bce.html
  set t_ut=
endif
syntax on
colorscheme molokai


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Beautifulness.
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! PrettyOn()
    set relativenumber
    set cursorcolumn
    set cursorline
endfun

fun! PrettyOff()
    set norelativenumber
    set number
    set nocursorcolumn
    set nocursorline
endfun

"
" Thanks to http://stackoverflow.com/questions/6496778/vim-run-autocmd-on-all-filetypes-except
let blacklist = ['nerdtree', 'taglist']
autocmd BufEnter * if index(blacklist, &ft) < 0 | call PrettyOn()
autocmd WinEnter * if index(blacklist, &ft) < 0 | call PrettyOn()
autocmd WinLeave * if index(blacklist, &ft) < 0 | call PrettyOff()
autocmd InsertEnter * if index(blacklist, &ft) < 0 | :set number
autocmd InsertLeave * if index(blacklist, &ft) < 0 | :set relativenumber

" autocmd FocusGained * call s:UpdateNERDTree()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ag/Ack
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" use Ack for searching, and do *not* open first result
set runtimepath^=~/.vim/bundle/ag.vim"
let g:ackprg = '/usr/local/bin/ag --nogroup --nocolor --column'
map <leader>a :Ag!<space>
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Markdown
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:markdown_fenced_languages = ['html', 'css', 'javascript', 'python', 'bash=sh']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RainbowParentheses
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" syntastic.vim
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:syntastic_javascript_checkers = ['eslint']

set statusline+=%{fugitive#statusline()}
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python/Jedi
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:jedi#usages_command = ""
let g:jedi#popup_on_dot = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" JSX
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:jsx_ext_required = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Airline
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_theme='luna'
"
"
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Buffers
" http://joshldavis.com/2014/04/05/vim-tab-madness-buffers-vs-tabs/
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" My preference with using buffers. See `:h hidden` for more details
set hidden

" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
" nmap <leader>T :enew<cr>

" Move to the next buffer
nmap <leader>l :bnext<CR>

" Move to the previous buffer
nmap <leader>h :bprevious<CR>

" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>bq :bp <BAR> bd #<CR>

" Show all open buffers and their status
nmap <leader>bl :ls<CR>

" toggle buffers
nmap <leader>bb :b#<CR>
" map <D-]> :bn<CR>
" map <D-[> :bp<CR>
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Convenience and whatnot
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufWritePre * :call <SID>StripWhite()
fun! <SID>StripWhite()

    if &ft =~ 'markdown'
        return
    endif

    let l = line(".")
    let c = col(".")
    %s/[ \t]\+$//ge
    %s!^\( \+\)\t!\=StrRepeat("\t", 1 + strlen(submatch(1)) / 8)!ge
    call cursor(l, c)
endfun

