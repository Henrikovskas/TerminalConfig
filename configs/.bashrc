set -o vi
if [[ $OSTYPE == "darwin20" ]]; then
	alias ls="ls -G"
else
	alias ls="ls --color=auto"
fi

unset HISTFILE
bind -x '"\C-l": clear'
PS1="\[\e[1;32m\h\e[m:\e[1;32m\W\e[m\$\] "
