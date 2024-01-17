#!/bin/zsh

# zcomet as zsh plugin manager
if [[ ! -e ~/.zcomet/bin ]]; then
  git clone --depth=1 https://github.com/agkozak/zcomet.git ~/.zcomet/bin
fi

# Activate Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.zcomet/bin/zcomet.zsh

# Options
setopt EXTENDED_GLOB
setopt GLOBDOTS

# Environment variables
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
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

# FZF

# Catppuccin Macchiato
export FZF_DEFAULT_OPTS=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"

# vivid for LS_COLORS
export LS_COLORS="$(vivid generate catppuccin-macchiato)"

# magic-enter
MAGIC_ENTER_GIT_COMMAND='gst'
MAGIC_ENTER_OTHER_COMMAND='la'

# zsh-autosuggestions
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Paths
# -U ensures each entry in these is Unique (that is, discards duplicates)
export -U PATH path FPATH fpath MANPATH manpath
# -T creates a "tied" pair
export -UT INFOPATH infopath

# $PATH and $path (and also $FPATH and $fpath, etc.) are "tied" to each other.
# Modifying one will also modify the other.
# Note that each value in an array is expanded separately. Thus, we can use ~
# for $HOME in each $path entry.
# (N) omits the item if it doesn't exist.
path=(
  $HOMEBREW_PREFIX/bin(N)
  $HOMEBREW_PREFIX/sbin(N)
  $HOMEBREW_PREFIX/opt/php@8.0/bin(N)
  $HOMEBREW_PREFIX/opt/php@8.0/sbin(N)
  $HOMEBREW_PREFIX/opt/fzf/bin(N)
  $HOME/.local/bin(N)
  $HOME/.local/share/bob/nvim-bin(N)
  $path[@]
)

# asdf
[ -s "$HOME/.asdf/asdf.sh" ] && source "$HOME/.asdf/asdf.sh"
[ -s "$HOME/.asdf/plugins/golang/set-env.zsh" ] && source "$HOME/.asdf/plugins/golang/set-env.zsh"

# Add your functions to your $fpath, so you can autoload them.
fpath=(
  $HOMEBREW_PREFIX/share/zsh/site-functions(N)
  $ASDF_DIR/completions(N)
  $fpath[@]
)
# plugins
zcomet snippet https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/magic-enter/magic-enter.plugin.zsh
zcomet snippet https://github.com/eckertalex/lsd.plugin.zsh/blob/main/lsd.plugin.zsh
zcomet snippet https://github.com/eckertalex/git.plugin.zsh/blob/main/git.plugin.zsh
zcomet snippet https://github.com/eckertalex/pnpm.plugin.zsh/blob/main/pnpm.plugin.zsh
zcomet snippet "$HOME/.aliases"
[[ -s "$HOME/.personio.plugin.zsh" ]] && zcomet snippet "$HOME/.personio.plugin.zsh"
[[ -s "$HOME/dev/mu.plugin.zsh/mu.plugin.zsh" ]] && zcomet snippet "$HOME/dev/mu.plugin.zsh/mu.plugin.zsh"

zcomet load hlissner/zsh-autopair
zcomet load romkatv/powerlevel10k
zcomet load junegunn/fzf shell completion.zsh key-bindings.zsh
(( ${+commands[fzf]} )) || ~[fzf]/install --bin

zcomet load zsh-users/zsh-syntax-highlighting
zcomet load zsh-users/zsh-autosuggestions

# Ctrl-f
bindkey -s '^f' "tmux-sessionizer\n"

zcomet compinit

[[ -s "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
