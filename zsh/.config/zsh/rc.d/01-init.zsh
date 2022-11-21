#!/bin/zsh

##
# History settings
#
# Always set these first, so history is preserved, no matter what happens.
#

# Tell zsh where to store history.
HISTFILE=${XDG_DATA_HOME:=~/.local/share}/zsh/history

# Just in case: If the parent directory doesn't exist, create it.
[[ -d $HISTFILE:h ]] || mkdir -p $HISTFILE:h

# Max number of entries to keep in history file.
SAVEHIST=$(( 10 * 1000 ))       # Use multiplication for readability.

# Max number of history entries to keep in memory.
# Larger than $SAVEHIST for HIST_EXPIRE_DUPS_FIRST to work
HISTSIZE=$(( 1.2 * SAVEHIST ))  # Zsh recommended value

##
# Prompt
#

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

