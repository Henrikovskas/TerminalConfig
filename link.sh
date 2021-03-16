delete_files() {
	if [[ $1 ]]; then
		rm $HOME/$1
	fi
}

delete_files /.vimrc
ln -s $PWD/.vimrc $HOME/.vimrc
echo "linked vimrc"
	
delete_files /.zshrc
ln -s $PWD/.zshrc $HOME/.zshrc
echo "linked zshrc"

delete_files /.tmux.conf
ln -s $PWD/.tmux.conf $HOME/.tmux.conf
echo "linked tmuxconf"
