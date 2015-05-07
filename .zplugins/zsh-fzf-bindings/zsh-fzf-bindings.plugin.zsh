# Only load the keybindings if fzf is installed
if [[ -n "`whence fzf`" ]]; then
  source "${0:r:r}.zsh"
else
  ohno "fzf not found, not loading keybindings."
fi


