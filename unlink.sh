unlink() {
	if rm $HOME/$1; then
		echo "Removed $1."
	fi
}

if [[ $OSTYPE == "darwin20" ]]; then
	unlink .zshrc
else
	unlink .bashrc
fi

unlink .screenrc
unlink .vimrc
