" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'chriskempson/base16-vim'
"Plugin 'kien/ctrlp.vim'
"Plugin 'Raimondi/delimitMate'
"Plugin 'vim-scripts/grep.vim'
"Plugin 'vim-scripts/Align'
"Plugin 'scrooloose/nerdcommenter'
"Plugin 'scrooloose/nerdtree'
"Plugin 'scrooloose/syntastic'
"Plugin 'bling/vim-airline'
"Plugin 'tpope/vim-surround'
"Plugin 'rking/ag.vim'
"Plugin 'spf13/vim-autoclose'
"Plugin 'Lokaltog/vim-easymotion'
"Plugin 'shawncplus/phpcomplete.vim'
"Plugin 'Valloric/YouCompleteMe'
"Plugin 'docteurklein/php-getter-setter.vim'
"Plugin 'SirVer/ultisnips'
"Plugin 'honza/vim-snippets'
"Plugin 'godlygeek/tabular'
"Plugin 'mbbill/undotree'
"Plugin 'tpope/vim-repeat'

call vundle#end() 

"set path=path=~/bin,.,templates/,stemplates/,~/git/common/,~/public_html/web/include/,./templates,./stemplates,~/public_html/web,,
set encoding=utf-8
set nocompatible 
"filetype off

"autocmd! bufwritepost .vimrc source %
autocmd! bufnewfile,bufreadpost .htaccess* set ft=apache

" Editing ---------------------------------------------------------------------------------------{{{

" MOUSE
set mouse=n
nnoremap <Leader>m :call ToggleMouse()<CR>
function! ToggleMouse()
  if &mouse == 'a'
    set mouse=n
    echo "Mouse off"
  else
    set mouse=a
    echo "Mouse on"
  endif
endfunction

function! TogglePaste()
  DelimitMateSwitch
  if &paste
    set nopaste
  else
    set paste
  endif
endfunction
nmap <silent> ,p :call TogglePaste()<CR>

" TABS
set expandtab                   "et:    uses spaces instead of tab characters
set smarttab                    "sta:   helps with backspacing because of expandtab
set tabstop=2                   "ts:    number of spaces that a tab counts for
set shiftwidth=2                "sw:    number of spaces to use for autoindent
set softtabstop=2
set shiftround                  "sr:    rounds indent to a multiple of shiftwidth

" don't fuck up comments starting with hash
set cinkeys-=0#
set indentkeys-=0#

filetype indent on
filetype plugin on

au BufRead,BufNewFile *.tpl set filetype=smarty 

" PHP
au FileType php set cindent     "cin:   enables the second-most configurable indentation (see :help C-indenting).
au FileType html set cindent     "cin:   enables the second-most configurable indentation (see :help C-indenting).
au FileType smarty set smartindent     
" au FileType php set cinoptions=l1,c4,(s,U1,w1,m1,j1
au FileType php set cinwords=if,elif,else,for,while,try,except,finally,def,class
au FileType php set omnifunc=phpcomplete#CompletePHP

" set showmatch                   "sm:    flashes matching brackets or
let loaded_matchparen = 1

map ,c <Plug>Traditional

" FOLDING
set foldenable                  "fe:    enable folding
set foldmethod=marker           "fm:    use {{{}}} markers for forlding
"set foldcolumn=1                "fdc:   creates a small left-hand gutter for displaying fold info
let php_folding=1               "auto fold php classes and functions
" toggle fold under cursor
noremap  <silent> <space> :exe 'silent! normal! za'.(foldlevel('.')?'':'l')<cr>
" open all folds
noremap  <silent> ,f zR
" close all folds
noremap  <silent> ,F zM

" MISC
set backspace=indent,eol,start  "bs:    allows you to backspace over the listed character types
"set linebreak                   "lbr:   causes vim to not wrap text in the middle of a word
set wrap                        "wrap:  wraps lines by default
set nojoinspaces                "nojs:  prevents inserting two spaces after punctuation on a join (it's not 1990 anymore)
set listchars=tab:>-,eol:$      "lcs:   makes finding tabs easier during :set list
set lazyredraw                  "lz:    will not redraw the screen while running macros (goes faster)
set wildmode=longest,list,full
set wildmenu                    "wm:    better tab completion in ex mode
set infercase                   "ic:    ignore case on insert completion
set complete=.,w,b,u,t
set textwidth=0                 "tw:    don't wrap lines at 78 chars
set noswapfile                  "unk:   don't create .swp files, they're at best (and at worst) annoying
set confirm
" toggle paste mode
noremap ,v :set nopaste!<CR>:set nopaste?<CR>
"fix indenting
map ,ri gg=G          
map gf :vertical wincmd f<CR>

" -----------------------------------------------------------------------------------------------}}}

" Search ---------------------------------------------------------------------------------------{{{

set incsearch                   "is:    automatically begins searching as you type
set ignorecase                  "ic:    ignores case when pattern matching
set smartcase                   "scs:   ignores ignorecase when pattern contains uppercase characters
set hlsearch                    "hls:   highlights search results

" Use ctrl-n to unhighlight search results in normal mode:
nmap <silent> ,h :silent noh<CR>  

" -----------------------------------------------------------------------------------------------}}}

" Some custom functions ---------------------------------------------------------------------------------------{{{


function! NextWordOrColumn ()
  let l:line = getline('.')
  if l:line =~ '^|.\+|\s*$'
    let l:hit_bar = 0
    for i in range(col('.'), len(l:line))
      if l:hit_bar
        if l:line[i] != ' ' && l:line[i] != '|'
          call cursor(line('.'), i+1)
          return
        endif 
      elseif l:line[i] == '|'
        let l:hit_bar = 1
      endif
    endfor
  else
    call feedkeys('w', 'n')
  endif
endfunction


function! PrevWordOrColumn ()
  let l:line = getline('.')
  if l:line =~ '^|.\+|\s*$'
    let l:hit_bar = 0
    let l:hit_val = 0
    for i in range(0, col('.'))
      let j = col('.') - i
      if l:hit_bar
         if l:hit_val && l:line[j] == ' '
                   call cursor(line('.'), j+2)
       return
         elseif l:line[j] != ' '
             let l:hit_val = 1
         endif 
      elseif l:line[j] == '|'
         let l:hit_bar = 1
      endif
    endfor
  else
    call feedkeys('b', 'n')
  endif
endfunction

" -----------------------------------------------------------------------------------------------}}}

" Navigation ---------------------------------------------------------------------------------------{{{

" modify paging commands
nmap <silent> <C-d> 25j
nmap <silent> <C-u> 25k

" modify word jumping, so we jump columns in MySQL
nnoremap <silent> w :<C-u>call NextWordOrColumn()<CR>
nnoremap <silent> b :<C-u>call PrevWordOrColumn()<CR>

" I want to go to the first non-\s char way more than I want col 0, and ^ sucks to type
noremap  <silent> 0 ^
noremap  <silent> ^ 0

" -----------------------------------------------------------------------------------------------}}}

" Windows and Tabs ---------------------------------------------------------------------------------------{{{

" switch tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT

" quick window resize
nmap <C-l> :vertical res +1<CR>
nmap <C-k> :res +1<CR>
nmap <C-h> :vertical res -1<CR>
nmap <C-j> :res -1<CR>
nmap ,m :resize<CR>
nmap ,M :resize\|:vertical resize<CR>
nmap ,a :NERDTreeToggle<CR>
nmap ,s :<C-u>split scratch \| set nonumber foldcolumn=0 winfixheight<CR>
" nmap <silent> ,p <Plug>ToggleProject
nmap <silent> ,r :redr!<CR>
nmap <silent> ,d :bdelete<CR>
nmap <silent> ,w :bwipeout<CR>
nmap <silent> ,u :bunload<CR>
nmap <silent> ,o :only<CR>

" jumping between buffers
nnoremap <C-n> <C-w>j
nnoremap <C-p> <C-w>k

" NERDTree
let NERDChristmasTree=1

" rotate through buffers in tabline
"noremap <silent> <F2> :<C-u>bprev<CR> 
"noremap <silent> <F3> :<C-u>bnext<CR>

" toggle wrapping
" nmap <silent> ,p :set nowrap!<CR>:set nowrap?<CR>

" Remember last position in file
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" MISC
nmap ,cm :set mouse=c<CR>
nmap ,nm :set mouse=n<CR>
"set winminheight=0              " I'm not sure why Vim displays one line by default when 'maximizing' a split window with ctrl-_
"set winminwidth=0               " I'm not sure why Vim displays one line by default when 'maximizing' a split window with ctrl-_
set number
set showmode                    "smd:   shows current vi mode in lower left
"set cursorline                 "cul:   highlights the current line
set showcmd                     "sc:    shows typed commands
set cmdheight=2                 "ch:    make a little more room for error messages
" set scrolloff=2                 "so:    places a couple lines between the current line and the screen edge
set sidescrolloff=2             "siso:  places a couple lines between the current column and the screen edge
set laststatus=2                "ls:    makes the status bar always visible
set ttyfast                     "tf:    improves redrawing for newer computers
set viminfo='500,f1,:100,/100   "vi:    For a nice, huuuuuge viminfo file
set switchbuf=usetab            "swb:   Jumps to first window or tab that contains specified buffer instead of duplicating an open window
set showtabline=1               "stal:  Display the tabbar if there are multiple tabs. Use :tab ball or invoke Vim with -p
set hidden                      "hid:   allows opening a new buffer in place of an existing one without first saving the existing one
set equalalways                 "       allows winfixheight to work correctly

let g:showmarks_enable=0

let g:proj_window_width=45
let g:proj_window_increment=55

" -----------------------------------------------------------------------------------------------}}}

" Colors and syntax ---------------------------------------------------------------------------------------{{{

if &term == "xterm-256color" || &term == "screen"
  " use 256 colors
  set t_Co=256
  "colorscheme jellybeans
  colorscheme base16-tomorrow-night
endif

if has('gui_running')
  colorscheme base16-tomorrow-night
  set guifont=Inconsolata-Regular:h18
endif

syntax on                       "syn:   syntax highlighting
syn sync maxlines=500
" load all my syntax options
"source ~/.vim/syntax/mine.vim

" -----------------------------------------------------------------------------------------------}}}

" Status line and Tab line ---------------------------------------------------------------------------------------{{{

function! MyStatusLine()
    let s = '%*' " restore normal highlighting
    let s .= '%%%n '
    if bufname('') != '' " why is this such a pain in the ass? FIXME: there's a bug in here somewhere. Test with a split with buftype=nofile
        let s .= "%{ pathshorten(fnamemodify(expand('%F'), ':~:.')) }" " short-hand path of of the current buffer (use :ls to see more info)
        " let s .= "%{ expand('%f') }" " short-hand path of of the current buffer (use :ls to see more info)
    else
        let s .= '%f' " an empty filename doesn't make it through the above filters
    endif
    let f = '%F '
    let f .= expand('%:h')
    " let s .= '%F' 
    let s .= '%m' " modified
    let s .= '%r' " read-only
    let s .= '%w' " preview window
    let d = getcwd()
    let e = split(d, '/')
    " let s .= ' [' . e[-1] . '] '
    " let s .= ' [' . f . '] '
    let s .= ' %{fugitive#statusline()}'
    let s .= ' %<' " start truncating from here if the window gets too small
    let s .= '%=' " seperate right- from left-aligned
    let s .= '%l' " current line number
    let s .= ',%c' " column number
    let s .= ' of %L' " total line numbers
    let s .= ' %P' " Percentage through file
  "  let s .= "\n\n" 
    return s
endfunction
set statusline=%!MyStatusLine()

function! MyTabLine()
        let s = ''
        for i in range(tabpagenr('$'))
            " set up some oft-used variables
            let tab = i + 1 " range() starts at 0
            let winnr = tabpagewinnr(tab) " gets current window of current tab
            let buflist = tabpagebuflist(tab) " list of buffers associated with the windows in the current tab
            let bufnr = buflist[winnr - 1] " current buffer number
            let bufname = bufname(bufnr) " gets the name of the current buffer in the current window of the current tab

            let s .= '%' . tab . 'T' " start a tab
            let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#') " if this tab is the current tab...set the right highlighting
            let s .= ' #' . tab " current tab number
            let n = tabpagewinnr(tab,'$') " get the number of windows in the current tab
            if n > 1
                let s .= ':' . n " if there's more than one, add a colon and display the count
            endif
      let bufmodified = getbufvar(bufnr, "&mod")
            if bufmodified
                let s .= ' +'
            endif
            if bufname != ''
                let s .= ' ' . pathshorten(bufname) . ' ' " outputs the one-letter-path shorthand & filename
            else
                let s .= ' [No Name] '
            endif
        endfor
        let s .= '%#TabLineFill#' " blank highlighting between the tabs and the righthand close 'X'
        let s .= '%T' " resets tab page number?
        return s
endfunction
set tabline=%!MyTabLine()

function! Lcd(dir)
  let dir = a:dir
  exec("lcd ".dir) 
  exec('pwd')
endfunction

" -----------------------------------------------------------------------------------------------}}}

" vim: foldmethod=marker
" au BufEnter * if match( getline(1) , '^\#!') == 0 |
" \ execute("let b:interpreter = getline(1)[2:]") |
" \endif

" fun! CallInterpreter()
    " if exists("b:interpreter")
         " exec ("!".b:interpreter." %")
    " endif
" endfun

" map ,e :call CallInterpreter()<CR>
"
" Xdebug
let g:debuggerPort = 9001
" let g:debuggerMaxDepth=5
"

" CTRLP
let g:ctrlp_max_height          = 20
let g:ctrlp_max_files           = 0
let g:ctrlp_open_new_file       = 'h'
let g:ctrlp_open_multiple_files = 'hr'
let g:ctrlp_working_path_mode   = 0
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_custom_ignore       = { 'dir': '\v[\/](tests/coverage-report|vendor*test*|vendor*Test*|coverage)$', 'file': '', 'link': '', }
let g:ctrlp_follow_symlinks     = 1

map ,pd :CtrlPBookmarkDir<CR>

imap <S-Tab> <Plug>delimitMateS-Tab
let delimitMate_expand_cr = 1
" au FileType smarty let b:delimitMate_matchpairs = ""
"au FileType smarty let b:delimitMate_matchpairs = "%:%"
" au FileType smarty let b:delimitMate_nesting_quotes = ['%%']

" check php syntax
let g:checksyntax#okrx = ''

" sqlutilities
let g:sqlutil_keyword_case = '\U'

set tags=tags,tags.vendor

" fugitive
"
nmap ,gd :Gdiff<CR>
nmap ,gs :Gstatus<CR>

"let g:Powerline_symbols = 'fancy'
"let g:airline_powerline_fonts = 1

let g:syntastic_javascript_checkers = ['jshint']

let g:agprg="/usr/local/bin/ag --column"
"cmap ag Ag!

" youcompleteme
let g:ycm_autoclose_preview_window_after_insertion = 1
"let g:ycm_key_list_select_completion=['<C-n>', '<Down>']
"let g:ycm_key_list_previous_completion=['<C-p>', '<Up>']

" ultisnips
"let g:UltiSnipsExpandTrigger="<Tab>"
"let g:UltiSnipsJumpForwardTrigger="<Tab>"                                           
"let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"

let g:UltiSnipsExpandTrigger = "<nop>"
let g:ulti_expand_or_jump_res = 0
function ExpandSnippetOrCarriageReturn()
    let snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
        return snippet
    else
        return "\<CR>"
    endif
endfunction
inoremap <expr> <CR> pumvisible() ? "<C-R>=ExpandSnippetOrCarriageReturn()<CR>" : "\<CR>"

let g:UltiSnipsSnippetsDir=[$HOME."/.vim/UltiSnips"]
