syntax on
colorscheme peachpuff
highlight Comment cterm=bold
highlight Comment ctermfg=LightGreen

set autoindent
set hlsearch 
set number
set ruler

set backspace=indent,eol,start
"set expandtab "converts tabs to spaces
set tabstop=4 "how many spaces in a tab
set shiftwidth=4 "for autoindent
set softtabstop=4 "for when deleting

map <SPACE> <Leader>
map <Leader>w <C-w>w
map <Leader>d "_d 
map <Leader>y "*y

"set list listchars=tab:-»,trail:° "to see tabs and trailing whitespace
