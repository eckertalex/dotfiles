#!/bin/zsh

##
# lsd
#

alias ls="lsd --classify"
alias ll="lsd --classify --header --long"
alias la="lsd --classify --header --long --almost-all"
alias lC="lsd --classify --header --long --almost-all --sort time --group-dirs none"
alias lS="lsd --classify --header --long --almost-all --sort size --group-dirs none"
alias lt="lsd --tree --depth=2"

##
# yarn
#

alias y="yarn"

# Dependency management
alias yi="yarn install"
alias yl="yarn list"
alias yout="yarn outdated"
alias ya="yarn add"
alias yad="yarn add --dev"
alias yrm="yarn remove"

# Development
alias yst="yarn start"
alias yd="yarn dev"
alias yb="yarn build"
alias ylt="yarn lint"

# Testing
alias yt="yarn test"
alias ytc="yarn test --coverage"

