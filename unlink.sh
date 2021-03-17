unlink() {
  if rm $HOME/$1; then
    echo "Removed $1."
  fi
}

unlink .vimrc
unlink .zshrc
unlink .tmux.conf
