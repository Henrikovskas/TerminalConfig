colorscheme default
syntax on
"highlight Comment ctermfg=darkgrey
highlight Comment ctermfg=blue
"highlight Comment ctermfg=green
"set ruler



let g:netrw_liststyle = 3 "file explorer style
let g:netrw_banner = 0 "remove a parte de cima desnecessária
"let g:netrw_browse_split = 1 "abre o ficheiro selecionado num novo split

"let g:netrw_winsize = 25

"let g:netrw_banner = 0
"let g:netrw_liststyle = 3
"let g:netrw_browse_split = 4
"let g:netrw_altv = 1
"let g:netrw_winsize = 25
"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END



set autoindent
set nowrap
"set smartindent
"set cindent



set hlsearch "search highlight
"set ruler
"set ignorecase 
set number



"set noerrorbells
"set title
"set visualbell



map <SPACE> <Leader>
map <Leader>d "_d
map <Leader>y "*y
"map <Leader>j <C-F>
"map <Leader>k <C-B>
map <Up> 10k
map <Down> 10j
map <Leader>j <C-w>j
map <Leader>k <C-w>k
map <Leader>h <C-w>h
map <Leader>l <C-w>l
vnoremap <ESC> <C-c> 
"Dá remap do ctrl-c para esc para não ter delay a sair do visual mode

filetype plugin indent on
set tabstop=4 "show existing tabs with 4 spaces
set shiftwidth=4 "when using '>'
set expandtab "to type 4 spaces with tabs

"set lazyredraw
set backspace=indent,eol,start
