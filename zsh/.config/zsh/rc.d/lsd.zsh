#!/bin/zsh

alias ls="lsd --classify"
alias ll="lsd --classify --header --long"
alias la="lsd --classify --header --long --almost-all"
alias lC="lsd --classify --header --long --almost-all --sort time --group-dirs none"
alias lS="lsd --classify --header --long --almost-all --sort size --group-dirs none"
alias lt="lsd --tree --depth=2"

