set runtimepath^="$XDG_CONFIG_HOME"/vim/vimrc runtimepath+="$XDG_CONFIG_HOME"/vim/after
let &packpath = &runtimepath
source "$XDG_CONFIG_HOME"/vim/vimrc
