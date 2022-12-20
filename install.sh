# check if this is MacOS
[ "$OSTYPE" = "darwin20" ]
mac=$?

configs=("git-prompt.sh" "bashrc" "screenrc" "vimrc")
test "$mac" && configs+=("zshrc" "bash_profile" "init.lua" "tmux.conf")

get_link_path() {
	if [ "$1" = "init.lua" ]; then
		mkdir -p $HOME/.config/nvim
		link_path="$HOME/.config/nvim/$1"
	else
		link_path="$HOME/.$1"
	fi
}

unlink() {
	get_link_path $1

	# checks if there's a link already
	# (even if it points to an invalid file)
	if [ -L "$link_path" ]; then
		rm $link_path
		echo "Unlinked $1"
	else
		echo "error: could not unlink $1"
	fi
}

link() {
	get_link_path $1

	ln -s $PWD/configs/$1 $link_path

	if [ -e "$link_path" ]; then
		echo "Linked $1"
	else
		echo "error: could not link $1"
	fi
}

install_packer() {
	if [ ! -d ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]; then
		git clone --depth 1 https://github.com/wbthomason/packer.nvim\
		~/.local/share/nvim/site/pack/packer/start/packer.nvim
		echo "Installed Packer"
	fi
}

run() {
	# relink everything
	for config in "${configs[@]}"; do
		unlink "$config"
		link "$config"
	done

	test "$mac" && install_packer

	# install homebrew and casks
	which -s brew
	if [ "$?" -ne 0 ] && [ "$mac" ]; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		brew install\
			go zig\
			jq universal-ctags ripgrep screen tmux
		brew install --cask\
			rectangle
	fi
}

if [ ! -z "$*" ]; then
	"$@"
else
	run
fi
