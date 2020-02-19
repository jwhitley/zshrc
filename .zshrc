# John Whitley's .zshrc
#
# created June 2003 based on .cshrc of 1985 lineage
#

# Table of Contents
#   0. Optional startup profiling
#   1. Identify enabled oh-my-zsh style plugins
#   2. Function path, autoload, and completion setup
#      Done before everything else to avoid dependencies on .zalias/.zenviron
#   3. zsh feature setup and settings
#   4. Environment setup
#   5. Load aliases
#      Done after environment as aliases may use environment variables.
#   5. Misc global behavior settings
#   6. Misc global behavior settings
#   7. Per-shell startup commands
#

### 0. Optional startup profiling
#

# based on http://stackoverflow.com/questions/4351244
#
if [[ -n $ZSH_ENABLE_PROFILE ]]; then
  # set the trace prompt to include decimal hour/minute/seconds/thousandths,
  # script name, and line number
  PS4=$'%D{%H%M%S.%.} %N:%i> '

  # save file stderr to file descriptor 3 and redirect stderr (including trace
  # output) to a file with the script's PID as an extension
  exec 3>&2 2>$HOME/tmp/zsh-profile-log.$$
  # set options to turn on tracing and expansion of commands contained in the
  # prompt
  setopt xtrace prompt_subst
fi

### 1. Identify enabled oh-my-zsh style plugins
#
plugins=( zsh-history-substring-search zsh-vim-mode safe-paste yarn-completion )

# load OS-specific and system-specific plugin lists into $plugins
for pconfig ( $ZDOTDIR/.zlocal/$ZSHRC_OS/plugins $ZDOTDIR/.zlocal/this/plugins ); do
  if [[ -f $pconfig ]]; then
    plugins+=( `cat $pconfig` )
  fi
done

### 2. Function path, autoload, plugin, and completion setup
#

# add .zfunctions and all of its subdirs to fpath
fpath=($ZDOTDIR/.zfunctions/(*/)#(/) $ZDOTDIR/.zlocal/$ZSHRC_OS/zfunctions/(*/)#(/) $fpath)
# autoload all normal files (except emacs autosaves)
# in .zfunctions/ and its subdirs as functions
autoload -Uz $ZDOTDIR/.zfunctions/**/*~*~(.:t)

# Add all defined plugins to fpath. This must be done
# before running compinit.
for plugin ($plugins); do
  if is_plugin $ZDOTDIR $plugin; then
    fpath=($ZDOTDIR/.zplugins/$plugin $fpath)
  fi
done

# Setup completion after fpath setup, to pick up user-defined completion functions
weak_source $ZDOTDIR/.zcompletion/setup

for plugin ($plugins); do
  weak_source $ZDOTDIR/.zplugins/$plugin/$plugin.plugin.zsh
done
unset plugin plugins

### 3. zsh feature setup and settings
#

## ZLE settings
#  These settings are now in the zsh-vim-mode plugin

## Misc options
setopt NO_BEEP                   # Quiet like the Red October...
setopt BASH_AUTO_LIST  # Bash-style completion list on tab
setopt AUTO_MENU                 # Do completion cycling on subsequent tabs
setopt COMPLETE_IN_WORD          # Always complete at the cursor position
setopt PROMPT_SUBST
setopt KSH_GLOB

### Enable color
autoload -U colors
colors

# zmv is a powerful pattern-based renamer
#   type "zmv" on the command line for usage
autoload zmv

# Environment and Alias policies:
# Loading of the .zenviron and .zaliases content is split into a
# hierarchy:
# -- Load OS-specific code from .zlocal/$ZSHRC_OS
# -- then load host-specific code from .zlocal/this
# -- finally load global settings from .zenviron or .zaliases
#
# Configuration not appropriate for general usage goes into
# .zlocal/this, e.g. setters that activate features of the frameworks
# elsewhere in these rc files.

### 4. Environment setup
#

# Load system-specific environment
weak_source $ZDOTDIR/.zlocal/$ZSHRC_OS/zenviron
weak_source $ZDOTDIR/.zlocal/this/zenviron
# Load interactive shell environment
weak_source $ZDOTDIR/.zenviron

### 5. Alias setup
#
# Load system-specific aliases
weak_source $ZDOTDIR/.zlocal/$ZSHRC_OS/zaliases
weak_source $ZDOTDIR/.zlocal/this/zaliases
# Load interactive shell aliases
weak_source $ZDOTDIR/.zaliases

### 6. Misc global behavior settings
#
if [[ -t 0 ]]; then
    stty erase '^?'		 # Force correct backspace as DEL behavior
fi

if [[ ! -O /bin/su ]]; then
    setopt IGNORE_EOF		 # Ignore ^D to exit the shell, but not while sudo'ed
fi

## 7. Per-shell startup commands
#
# Set the window title in xterm, rxvt, or screen windows.
set-window-title

## 0. End startup profiling
#

if [[ -n $ZSH_ENABLE_PROFILE ]]; then
  # turn off tracing
  unsetopt xtrace
  # restore stderr to the value saved in FD 3
  exec 2>&3 3>&-
fi
