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

##
# Options
#

setopt EXTENDED_HISTORY         # Save time stamps and durations
setopt HIST_SAVE_NO_DUPS        # When writing out the history file, older commands that duplicate newer ones are omitted. 
setopt HIST_EXPIRE_DUPS_FIRST   # Expire duplicates first
setopt HIST_FCNTL_LOCK          # Use modern file-locking mechanisms, for better safety & performance.
setopt HIST_IGNORE_ALL_DUPS     # Keep only the most recent copy of each duplicate entry in history.
setopt SHARE_HISTORY            # Auto-sync history between concurrent sessions.
setopt NO_CLOBBER               # Don't let > overwrite files. To overwrite, use >| instead.
setopt INTERACTIVE_COMMENTS     # Allow comments to be pasted into the command line.
setopt HASH_EXECUTABLES_ONLY    # Don't treat non-executable files in your $path as commands.
setopt EXTENDED_GLOB            # Enable additional glob operators. (Globbing = pattern matching)
setopt GLOB_STAR_SHORT          # Enable ** and *** as shortcuts for **/* and ***/*, respectively.
setopt NUMERIC_GLOB_SORT        # Sort numbers numerically, not lexicographically.
setopt NO_MENU_COMPLETE         # do not autoselect the first completion entry
setopt GLOB_DOTS                # Do not require a leading ‘.’ in a filename to be matched explicitly. 
setopt GLOB_STAR_SHORT          # the pattern ‘**/*’ can be abbreviated to ‘**’ and the pattern ‘***/*’ can be abbreviated to ***
# Change dirs without `cd`. Just type the dir and press enter.
# NOTE: This will misfire if there is an alias, function, builtin or command
# with the same name!
# To be safe, use autocd only with paths starting with .. or / or ~ (including
# named directories).
setopt AUTO_CD

##
# Environment variables
#

export EDITOR=nvim
export VISUAL=nvim

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

# -U ensures each entry in these is Unique (that is, discards duplicates).
export -U PATH path FPATH fpath MANPATH manpath
export -UT INFOPATH infopath  # -T creates a "tied" pair; see below.

# $PATH and $path (and also $FPATH and $fpath, etc.) are "tied" to each other.
# Modifying one will also modify the other.
# Note that each value in an array is expanded separately. Thus, we can use ~
# for $HOME in each $path entry.
path=(
    $path
    ~/.local/bin
    $N_PREFIX/bin
    $PNPM_HOME
    ~/.cargo/bin
    /usr/local/opt/crowdin@3/bin
    ~/.adb-fastboot
)

# Add your functions to your $fpath, so you can autoload them.
fpath=(
    $HOME/.config/zsh/functions
    $fpath
)

##
# Plugin manager
#

local znap=$HOME/.config/zsh/git/zsh-snap/znap.zsh

# Auto-install Znap if it's not there yet.
if ! [[ -r $znap ]]; then   # Check if the file exists and can be read.
  mkdir -p $HOME/.config/zsh/git
  git -C $HOME/.config/zsh/git clone --depth 1 -- \
      https://github.com/marlonrichert/zsh-snap.git
fi

. $znap     # Load Znap.

##
# Plugins
#

# Add the plugins you want to use here.
# For more info on each plugin, visit its repo at github.com/<plugin>
# -a sets the variable's type to array.
local -a plugins=(
    marlonrichert/zsh-autocomplete             # Real-time type-ahead completion
    marlonrichert/zsh-edit                     # Better keyboard shortcuts
    # Highlighting issues, makes tab completion unreadable
    # marlonrichert/zcolors                      # Colors for completions and Git
    zsh-users/zsh-autosuggestions              # Inline suggestions
    zsh-users/zsh-syntax-highlighting          # Command-line syntax highlighting
    romkatv/powerlevel10k                      # prompt
    hlissner/zsh-autopair
    eckertalex/git.plugin.zsh
    eckertalex/pnpm.plugin.zsh
)

zstyle ':completion:*' completer \
    _expand _complete _complete:-loose _complete:-fuzzy _ignored
zstyle ':autocomplete:*' min-input 1
zstyle ':autocomplete:*' widget-style menu-select

# The Zsh Autocomplete plugin sends *a lot* of characters to your terminal.
# This is fine locally on modern machines, but if you're working through a slow
# ssh connection, you might want to add a slight delay before the
# autocompletion kicks in:
#   zstyle ':autocomplete:*' min-delay 0.5  # seconds
#
# If your connection is VERY slow, then you might want to disable
# autocompletion completely and use only tab completion instead:
#   zstyle ':autocomplete:*' async no


# Speed up the first startup by cloning all plugins in parallel.
# This won't clone plugins that we already have.
znap clone $plugins

# Load each plugin, one at a time.
local p=
for p in $plugins; do
  znap source $p
done

# `znap eval <name> '<command>'` is like `eval "$( <command> )"` but with
# caching and compilation of <command>'s output, making it ~10 times faster.
# znap eval zcolors zcolors   # Extra init code needed for zcolors.

##
# Key bindings
#
# zsh-autocomplete and zsh-edit add many useful keybindings. See each of their
# respective docs for the full list:
# https://github.com/marlonrichert/zsh-autocomplete/blob/main/README.md#key-bindings
# https://github.com/marlonrichert/zsh-edit/blob/main/README.md#key-bindings
#

# Enable the use of Ctrl-Q and Ctrl-S for keyboard shortcuts.
unsetopt FLOW_CONTROL

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

# Alt-Shift-S: Prefix the current or previous command line with `sudo`.
() {
  bindkey '^[S' $1  # Bind Alt-Shift-S to the widget below.
  zle -N $1         # Create a widget that calls the function below.
  $1() {            # Create the function.
    [[ -z $BUFFER ]] && zle .up-history
    LBUFFER="sudo $LBUFFER"   # Use $LBUFFER to preserve cursor position.
  }
} .sudo

##
# Commands, funtions and aliases
#
# Always set aliases _last,_ so they don't class with function definitions.
#

# These aliases enable us to paste example code into the terminal without the
# shell complaining about the pasted prompt symbol.
alias %= \$=

# Note that, unlike Bash, there's no need to inform Zsh's completion system
# of your aliases. It will figure them out automatically.

# Set $PAGER if it hasn't been set yet. We need it below.
# `:` is a builtin command that does nothing. We use it here to stop Zsh from
# evaluating the value of our $expansion as a command.
: ${PAGER:=less}

# Associate file .extensions with programs.
# This lets you open a file just by typing its name and pressing enter.
# Note that the dot is implicit. So, `gz` below stands for files ending in .gz
alias -s {css,gradle,html,js,json,md,patch,properties,txt,xml,yml}=$PAGER
alias -s {log,out}='tail -F'

# Use `< file` to quickly view the contents of any file.
READNULLCMD=$PAGER  # Set the program to use for this.

# Pattern matching support for `cp`, `ln` and `mv`
# See http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#index-zmv
# Tip: Use -n for no execution. (Print what would happen, but don’t do it.)
autoload -Uz zmv
alias \
    zmv='zmv -v' \
    zcp='zmv -Cv' \
    zln='zmv -Lv'

##
# Aliases
#

. $HOME/.config/zsh/aliases.zsh

##
# Theme
#

. $HOME/.config/zsh/catppuccin-macchiato.zsh

##
# zoxide
#

znap eval zoxide 'zoxide init zsh'

##
# FZF
#

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

fzf-git-branch() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    git branch --color=always --all --sort=-committerdate |
        grep -v HEAD |
        fzf --height 50% --ansi --no-multi --preview-window right:65% \
            --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
        sed "s/.* //"
}

fzf-git-checkout() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    local branch

    branch=$(fzf-git-branch)
    if [[ "$branch" = "" ]]; then
        echo "No branch selected."
        return
    fi

    # If branch name starts with 'remotes/' then it is a remote branch. By
    # using --track and a remote branch name, it is the same as:
    # git checkout -b branchName --track origin/branchName
    if [[ "$branch" = 'remotes/'* ]]; then
        git checkout --track $branch
    else
        git checkout $branch;
    fi
}

alias fgsw='fzf-git-checkout'

