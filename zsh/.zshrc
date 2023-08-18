#!/bin/zsh

##
# Plugin manager
#

# Make plugin folder names pretty
zstyle ':antidote:bundle' use-friendly-names 'yes'
export ANTIDOTE_HOME=$HOME/.cache/antidote

[[ -d $HOME/.antidote ]] ||
  git clone https://github.com/mattmc3/antidote $HOME/.antidote

source $HOME/.antidote/antidote.zsh
antidote load

# place this after nvm initialization!
autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

##
# Options
#
setopt EXTENDED_GLOB

##
# Environment variables
#

export PAGER=less
export EDITOR=nvim
export VISUAL=nvim

# Homebrew

export HOMEBREW_NO_ANALYTICS=1
if [[ "$OSTYPE" == "darwin"* ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# fzf
if [[ "$OSTYPE" == "darwin"* ]]; then
	source "/opt/homebrew/opt/fzf/shell/completion.zsh"
	source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
	source "/home/linuxbrew/.linuxbrew/opt/fzf/shell/completion.zsh"
	source "/home/linuxbrew/.linuxbrew/opt/fzf/shell/key-bindings.zsh"
fi

# FZF
export FZF_DEFAULT_OPTS="\
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"

# pnpm
export PNPM_HOME=$HOME/.local/share/pnpm

# vivid for LS_COLORS
export LS_COLORS="$(vivid generate catppuccin-macchiato)"

# magic-enter 
MAGIC_ENTER_GIT_COMMAND='gss'
MAGIC_ENTER_OTHER_COMMAND='la'

##
# Paths
#

# -U ensures each entry in these is Unique (that is, discards duplicates).
export -U PATH path FPATH fpath MANPATH manpath
# -T creates a "tied" pair; see below.
export -UT INFOPATH infopath

# $PATH and $path (and also $FPATH and $fpath, etc.) are "tied" to each other.
# Modifying one will also modify the other.
# Note that each value in an array is expanded separately. Thus, we can use ~
# for $HOME in each $path entry.
# (N) omits the item if it doesn't exist.
path=(
  $HOMEBREW_PREFIX/bin(N)
  $HOMEBREW_PREFIX/sbin(N)
  $HOMEBREW_PREFIX/opt/fzf/bin(N)
  $HOME/.local/bin(N)
  $HOME/.cargo/bin(N)
  $HOME/.adb-fastboot(N)
  $N_PREFIX/bin(N)
  $PNPM_HOME(N)
  $path[@]
)

# Add your functions to your $fpath, so you can autoload them.
fpath=(
  $HOME/.zfunctions(N)
  $HOMEBREW_PREFIX/share/zsh/site-functions(N)
  $fpath[@]
)

[[ -s "$HOME/.personio.plugin.zsh" ]] && source "$HOME/.personio.plugin.zsh"

##
# Powerlevel10k
#

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -s "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
