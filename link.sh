link() {
	if [[ -e $HOME/$1 ]]; then
		rm $HOME/$1
		echo "Removed already present file $1."
	fi

	ln -s $PWD/configs/$1 $HOME/$1

	if [[ $? == 0 && -L $HOME/$1 ]]; then
		echo "Linked $1."
	fi
}

if [[ $OSTYPE == "darwin20" ]]; then
	link .zshrc
else
	link .bashrc
fi
link .screenrc
link .vimrc
