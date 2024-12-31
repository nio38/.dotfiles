#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# PS1='[\u@\h \W]\$ '
#PS1='\[\e[1;94m\]  \[\e[0m\]\[\e[1;35m\]\W \[\e[0m\]'
PS1='\[\e[1;35m\]\w $ \[\e[0m\]'


## MODIFICATIONS

## pywal 
(cat ~/.cache/wal/sequences &)

neofetch

## vim
alias vi='vim'

