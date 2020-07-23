export LC_ALL=en_US.UTF-8 #mete a lingua do env em inglês para não dar erro com o vim
set -o vi
alias cdd='cd Desktop'
alias python=python3
unsetopt prompt_cr prompt_sp #Evita a cena de pôr um sinal de percentagem se a output tiver na mesma linha da command line

#% prompt='%/ %# '
prompt='%F{blue}%m%f:%F{yellow}%~%f: '
