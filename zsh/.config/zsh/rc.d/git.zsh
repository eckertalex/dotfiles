#!/bin/zsh

alias gprev="git checkout @{-1}"
alias guncommit="git reset HEAD~1"
alias fco="git branch --all --format=\"%(refname:short)\" | fzf --height 10% --layout=reverse --border | xargs git checkout"
