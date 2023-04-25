#!/bin/zsh

if [ -z "$TMUX" ] && [ ${UID} != 0 ]; then
    tmux new-session -A -s main
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

##
# Options
#

# Globbing
setopt EXTENDED_GLOB
setopt NO_CASE_GLOB             # case insensitive globbing
setopt GLOB_COMPLETE            # insert all the matches resulting from a glob
setopt NO_CLOBBER               # Don't let > overwrite files. To overwrite, use >| instead.
setopt GLOB_STAR_SHORT          # Enable ** and *** as shortcuts for **/* and ***/*, respectively.
setopt NUMERIC_GLOB_SORT        # Sort numbers numerically, not lexicographically.
setopt GLOB_DOTS                # Do not require a leading ‘.’ in a filename to be matched explicitly. 

# History
setopt SHARE_HISTORY            # Auto-sync history between concurrent sessions
setopt APPEND_HISTORY           # append to history
setopt HIST_FCNTL_LOCK          # Use modern file-locking mechanisms, for better safety & performance

# Spell correction
setopt CORRECT                  # Try to correct the spelling
setopt CORRECT_ALL              # Try to correct the spelling of all arguments in a line

# Misc
setopt AUTO_CD                  # Change dirs without `cd`
setopt INTERACTIVE_COMMENTS     # Allow comments to be pasted into the command line.
setopt HASH_EXECUTABLES_ONLY    # Don't treat non-executable files in your $path as commands.

##
# Environment variables
#

export PAGER=less
export MANPAGER='bat -l man'
# Use `< file` to quickly view the contents of any file.
export READNULLCMD=bat
export EDITOR=nvim
export VISUAL=nvim

# Homebrew
eval "$(brew shellenv)"

# n
export N_PREFIX=$HOME/.n

# pnpm
export PNPM_HOME=$HOME/.local/share/pnpm

# FZF
export FZF_DEFAULT_OPTS="\
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"

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
  $HOME/.local/bin(N)
  $HOME/.cargo/bin(N)
  $HOME/.adb-fastboot(N)
  $HOMEBREW_PREFIX/opt/{crowdin@3,fzf}/bin(N)
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

# fzf
if [[ "$OSTYPE" == "darwin"* ]]; then
	source "/usr/local/opt/fzf/shell/completion.zsh"
	source "/usr/local/opt/fzf/shell/key-bindings.zsh"
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
	source "/usr/share/doc/fzf/examples/completion.zsh"
	source "/usr/share/doc/fzf/examples/key-bindings.zsh"
fi

##
# Key bindings
#

# Alt-H: Get help on your current command.
() {
  unalias $1 2> /dev/null   # Remove the default.

  # Load the more advanced version.
  # -R resolves the function immediately, so we can access the source dir.
  autoload -UzR $1

  # Load the hash table that maps each function to its source file.
  zmodload -F zsh/parameter p:functions_source

  # Lazy-load all the run-help-* helper functions from the same dir.
  autoload -Uz $functions_source[$1]-*~*.zwc  # Exclude .zwc files.
} run-help

# Alt-Q
# - On the main prompt: Push aside your current command line  so you can type a
#   new one. The old command line is restored when you press Alt-G or once
#   you've accepted the new command line.
# - On the continuation prompt: Return to the main prompt.
bindkey '^[q' push-line-or-edit

# Alt-V: Show the next key combo's terminal code and state what it does.
bindkey '^[v' describe-key-briefly

##
# Commands, funtions and aliases
#
# Always set aliases _last,_ so they don't class with function definitions.
#

alias mvim="NVIM_APPNAME=mvim nvim"

# Associate file .extensions with programs.
alias -s {css,gradle,html,js,json,md,patch,properties,txt,xml,yml}=bat
alias -s {log,out}='tail -F'

##
# Powerlevel10k
#

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

