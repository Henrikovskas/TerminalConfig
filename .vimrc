syntax on
highlight Comment ctermfg=blue 
"more like purple
set autoindent
set nowrap
set hlsearch "search highlight
"set ignorecase 
set number

let g:netrw_liststyle = 3 "file explorer style
let g:netrw_banner = 0 "remove a parte de cima desnecessária
"let g:netrw_browse_split = 1 "abre o ficheiro selecionado num novo split

map <SPACE> <Leader>
map <Leader>d "_d
map <Leader>y "*y
map <Up> 15k
map <Down> 15j
map <Leader>j <C-w>j
map <Leader>k <C-w>k
map <Leader>h <C-w>h
map <Leader>l <C-w>l
vnoremap <ESC> <C-c> 
"Remaps ctrl-c to esc to remove delay when exiting visual mode

set tabstop=4 "show existing tabs with 4 spaces
set shiftwidth=4 "when using '>'
set expandtab "to type 4 spaces with tabs

set lazyredraw "better performance
