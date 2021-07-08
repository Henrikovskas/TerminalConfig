which -s brew
if [[ $OSTYPE == "darwin20" && $? != 0 ]]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew install wget
	brew install htop
fi
./unlink.sh
./link.sh
