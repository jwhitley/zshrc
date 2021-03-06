# John Whitley's .zshenv
#
# created June 2003
# updated October 2003
#

setopt EXTENDED_GLOB	# Enable zsh Uber-glob features in all zsh instances

# Make sure that $ZDOTDIR is set
if [[ -z $ZDOTDIR ]]; then
  export ZDOTDIR=$HOME
fi

# Load global (interactive and non-interactive) shell functions
source $ZDOTDIR/.zglobalfns

# make sure that hostname is set
if [[ -z $HOSTNAME ]]; then export HOSTNAME=`hostname`; fi

# get uname
ZSH_UNAME=`uname`

# set platform predicates
if [[ $ZSH_UNAME == "Darwin" ]]; then
  is_macosx=true
  export ZSHRC_OS=mac
elif [[ $ZSH_UNAME == "Linux" ]]; then
  is_linux=true
  export ZSHRC_OS=linux
fi

unset ZSH_UNAME

if [[ -n "$SSH_CONNECTION" ]]; then
  export ZSHRC_IS_REMOTE=1
fi

export RSYNC_RSH=`which ssh`

# Load system-specific global environment
weak_source $ZDOTDIR/.zlocal/$ZSHRC_OS/zshenv
weak_source $ZDOTDIR/.zlocal/this/zshenv

# Local Variables:
# mode: shell-script
# End:
