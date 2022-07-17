unlink() {
	if rm $HOME/$1; then
		echo "Removed $1."
	fi
}

link() {
	if [[ -e $HOME/$2 ]]; then
		rm $HOME/$2
		echo "Removed already present file $2."
	fi

	ln -s $PWD/configs/$1 $HOME/$2

	if [[ $? == 0 && -L $HOME/$2 ]]; then
		echo "Linked $1."
	fi
}

unlink_all() {
	if [[ $OSTYPE == "darwin20" ]]; then
		unlink .zshrc
		unlink .vim/coc-settings.json
	fi
	unlink .tmux.conf
	unlink .bashrc
	unlink .bash_profile
	unlink .screenrc
	unlink .vimrc
}

link_all() {
	if [[ $OSTYPE == "darwin20" ]]; then
		link zshrc .zshrc
		link coc-settings.json .vim/coc-settings.json
	fi
	link tmux.conf .tmux.conf
	link bashrc .bashrc
	link bash_profile .bash_profile
	link screenrc .screenrc
	link vimrc .vimrc
}

unlink_all
link_all

# check if it's first time setup and install required components
which -s brew
if [[ $OSTYPE == "darwin20" && $? != 0 ]]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	brew install wget htop node bear go gopls fmt ripgrep rust rustfmt rustup-init tree cmake jq zig

	# zls setup (zig)
	mkdir $HOME/zls && cd $HOME/zls && curl -L https://github.com/zigtools/zls/releases/download/0.9.0/x86_64-macos.tar.xz | tar -xJ --strip-components=1 -C .
	cd ~/zls && chmod +x zls

	# Run manually in vim:
	# :PlugInstall
	# :CocInstall coc-clangd
	# :CocCommand clangd.install
	# :CocInstall coc-rust-analyzer
fi

