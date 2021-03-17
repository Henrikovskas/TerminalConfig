link() {
	if [[ -e $HOME/$1 ]]; then
	  rm $HOME/$1
    echo "Removed already present file $1."
	fi
  
  ln -s $PWD/$1 $HOME/$1

  if [[ -L $HOME/$1 ]]; then
    echo "Linked $1."
  else 
    echo "Error: could not link $1."
  fi
}

link .vimrc
link .zshrc
link .tmux.conf
