colorscheme default
syntax on
highlight Comment ctermfg=green
set autoindent
set cindent
"set nowrap
set hlsearch 
set ignorecase 
set number
set ruler

set backspace=indent,eol,start

map <SPACE> <Leader>
map <Leader>d "_d 
map <Leader>y "*y
map <Leader>f <C-f>
map <Leader>b <C-b>
map <Leader>j <C-w>j
map <Leader>k <C-w>k
map <Leader>h <C-w>h
map <Leader>l <C-w>l

set expandtab "converts tabs to spaces
set tabstop=2 "how many spaces in a tab
set shiftwidth=2 "for autoindent
set softtabstop=2 "for when deleting
