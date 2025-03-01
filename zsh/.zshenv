#!/bin/zsh
#
# .zshenv: Zsh environment file, loaded always.
#

# XDG
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}

export PAGER=less
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export EDITOR=nvim
export VISUAL=nvim

# vim: set ts=4 sw=4
