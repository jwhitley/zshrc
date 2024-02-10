# zsh-cdhelper.zsh
#
# zsh functions to create cd-like commands with full
# completion support.

# cdhelper -- A function to generate cd-like functions for specific subdirs
# Usage: cdhelper <alias> <base path>
#
#   cdhelper creates a function named as <alias> which acts like the
#   command "cd <base_path>" Any arguments to <alias> are appended to
#   <base_path>, and zsh completion support is enabled for <alias>, so
#   that subdirs of <base path> may easily be navigated.
#
# Example:
#   # starting in $HOME
#   ~$ cdhelper src ~/src
#   ~$ src
#   # now in ~/src
#   ~/src$ src foobar
#   # now in ~/src/foobar
#   ~/src/foobar$ 

cdhelper() {
  local fn=$1
  local dir="$2"
  
  if [[ ! -d "$2" ]]; then
    return
  fi
  # create access function
  eval "function $fn () {
    if [[ \$# -gt 0 ]]; then 
      cd \"$dir/\$1\"

    else
      cd \"$dir\"
    fi
  }"

  eval "function _$1() {
    _path_files -/ -W '$2'
  }"

  compdef _$1 $1
}

# wt -- change directory into an adjacent git working tree
wt() {
  local toplevel
  toplevel=$(git rev-parse --show-toplevel 2> /dev/null)
  if [[ $? -gt 0 ]]; then
    echo "Not in a git repo"
    return
  fi

  local prefix=$(dirname "$toplevel")
  if [[ $# -gt 0 ]]; then 
    cd "$prefix/$1"
  else
    echo "No path passed; staying put"
  fi
}

# Completion currently assumes that all worktrees share a common parent
# directory
_wt() {
  local toplevel
  toplevel=$(git rev-parse --show-toplevel 2> /dev/null)
  if [[ $? -gt 0 ]]; then
    _message "Not in a git repo"
    return
  fi

  if compset -P '*/'; then
    _path_files -/ -W $(realpath ../$IPREFIX)
  else
    local prefix="$(realpath ${toplevel}/..)/"
    local worktrees
    worktrees=("${(@f)$(git worktree list | sed -E -e "s|^${prefix}||" -e "s|^([[:alnum:]/_-]+) +|\1:|" )}")
    _describe -t worktree 'worktrees' worktrees -S '/'
  fi
}

compdef _wt wt

