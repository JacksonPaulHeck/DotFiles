#
# ~/.bashrc
#
clear
# If not running interactively, don't do anything
[[ $- != *i* ]] && return
neofetch
alias vim='nvim'
alias ls='exa -lha --color=auto'
alias clear='clear && neofetch'
alias cls='clear'
alias startx='startx --config /home/jpheckles/.config/X11/xinitrc'
export HISTFILE="${XDG_STATE_HOME}"/bash/history
export XINITRC="${XDG_CONFIG_HOME}"/X11/xinit/xinitrc
export XAUTHORITY="${XDG_RUNTIME_DIR}"/Xauthority
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export GVIMINIT='let $MYGVIMRC="$XDG_CONFIG_HOME/vim/gvimrc" | source $MYGVIMRC'
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
export STACK_ROOT="$XDG_DATA_HOME"/stack

if [ ! -f $XAUTHORITY ]
then
    touch $XAUTHORITY 
fi

PS1='[\u@\h \W]\$ '

alias config='/usr/bin/git --git-dir=/home/jpheckles/.cfg/ --work-tree=/home/jpheckles'
. "/home/jpheckles/.local/share/cargo/env"
