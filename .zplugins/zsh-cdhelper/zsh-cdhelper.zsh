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


