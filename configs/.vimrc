syntax on
colorscheme default
hi Comment ctermfg=green

set autoindent
set hlsearch 
set number
set ruler
set nowrap

set backspace=indent,eol,start
set tabstop=2 "how many spaces in a tab
set shiftwidth=2 "for autoindent
set softtabstop=2 "for when deleting
"set expandtab "converts tabs to spaces

map <SPACE> <Leader>
map <Leader>w <C-w>w
map <Leader>d "_d 
map <Leader>y "*y

"set list listchars=tab:-»,trail:° "to see tabs and trailing whitespace
let g:go_highlight_trailing_whitespace_error=0
