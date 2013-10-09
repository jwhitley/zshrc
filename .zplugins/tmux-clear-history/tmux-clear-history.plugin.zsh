clear-screen-and-tmux-history () {
  zle clear-screen

  if [[ ${+TMUX} == 1 ]]; then
    sched +1 tmux clear-history
  fi
}

zle -N clear-screen-and-tmux-history
