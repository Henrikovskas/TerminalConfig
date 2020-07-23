export LC_ALL=en_US.UTF-8 #sets language to english to avoid conflicts with vim

set -o vi #set terminal mode to vim
alias cdd='cd Desktop'
alias lss='ls -a -l'
alias python=python3
unsetopt prompt_cr prompt_sp #removes '%' if there is no '\n'

prompt='%F{blue}%m%f:%F{yellow}%~%f: '
