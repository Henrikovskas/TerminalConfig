unlink() {
	if rm $HOME/$1; then
		echo "Removed $1."
	fi
}

if [[ $OSTYPE == "darwin20" ]]; then
	unlink .zshrc
fi
unlink .bashrc
unlink .screenrc
unlink .vimrc
