#!/bin/zsh
#
# .zshrc - Run on interactive Zsh session.
#

################
# powerlevel10k
################

if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
fi

####################
# plugin management
####################

function zcompile-many() {
	local f
	for f; do
		zcompile -R -- "$f".zwc "$f";
	done
}

ZPLUGINDIR="$XDG_DATA_HOME/zsh/plugins"
if [[ ! -d "$ZPLUGINDIR/zsh-syntax-highlighting" ]]; then
	git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZPLUGINDIR/zsh-syntax-highlighting"
	zcompile-many $ZPLUGINDIR/zsh-syntax-highlighting/{zsh-syntax-highlighting.zsh,highlighters/*/*.zsh}
fi
if [[ ! -d "$ZPLUGINDIR/zsh-autosuggestions" ]]; then
	git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$ZPLUGINDIR/zsh-autosuggestions"
	zcompile-many $ZPLUGINDIR/zsh-autosuggestions/{zsh-autosuggestions.zsh,src/**/*.zsh}
fi
if [[ ! -d "$ZPLUGINDIR/powerlevel10k" ]]; then
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZPLUGINDIR/powerlevel10k"
	make -C "$ZPLUGINDIR/powerlevel10k" pkg
fi

##########
# Options
##########

setopt GLOBDOTS
setopt INC_APPEND_HISTORY     # Immediately append to history file.
setopt EXTENDED_HISTORY       # Record timestamp in history.
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS       # Dont record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a line previously found.
setopt HIST_IGNORE_SPACE      # Dont record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS      # Dont write duplicate entries in the history file.
setopt SHARE_HISTORY          # Share history between all sessions.
unsetopt HIST_VERIFY          # Execute commands using history (e.g.: using !$) immediately

########################
# Environment variables
########################

HISTFILE="$XDG_DATA_HOME/zsh/zsh_history"
HISTSIZE=50000
SAVEHIST=50000

# -U ensures each entry in these is Unique (that is, discards duplicates)
# -T creates a "tied" pair
export -U PATH path FPATH fpath MANPATH manpath
export -UT INFOPATH infopath
PATH="$HOME/.local/bin:$PATH"
FPATH="$ZDOTDIR/completions:$FPATH"

###########
# Homebrew
###########

export HOMEBREW_NO_ANALYTICS=1
case $OSTYPE in
	darwin*)
		eval "$(/opt/homebrew/bin/brew shellenv)"
		;;
esac

if type brew &> /dev/null; then
	PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
	FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH"
fi

######
# FZF
######

[[ -r "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh" ]] && source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
[[ -r "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh" ]] && source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"

##########
# THEMING
##########

[[ -r "$XDG_CONFIG_HOME/lscolors/rose-pine.sh" ]] && source "$XDG_CONFIG_HOME/lscolors/rose-pine.sh"
[[ -r "$XDG_CONFIG_HOME/fzf/rose-pine.sh" ]] && source "$XDG_CONFIG_HOME/fzf/rose-pine.sh"
export BAT_THEME="rose-pine"

#######
# asdf
#######

export ASDF_DATA_DIR="$HOME/.asdf"
PATH="$ASDF_DATA_DIR/shims:$PATH"

###########
# compinit
###########

# Enable the "new" completion system (compsys).
autoload -Uz compinit && compinit
[[ "$ZDOTDIR/.zcompdump.zwc" -nt "$ZDOTDIR/.zcompdump" ]] || zcompile-many "$ZDOTDIR/.zcompdump"
unfunction zcompile-many

######
# vim
######

# vi mode
bindkey -v
export KEYTIMEOUT=1

# edit current command in vim with CTRL-e
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Set cursor style (DECSCUSR), VT520.
# 0  ⇒  blinking block.
# 1  ⇒  blinking block (default).
# 2  ⇒  steady block.
# 3  ⇒  blinking underline.
# 4  ⇒  steady underline.
# 5  ⇒  blinking bar, xterm.
# 6  ⇒  steady bar, xterm.

# Change cursor shape for different vi modes.
function zle-keymap-select {
	if [[ ${KEYMAP} == vicmd ]] ||
		[[ $1 = 'block' ]]; then
			echo -ne '\e[2 q'
		elif [[ ${KEYMAP} == main ]] ||
			[[ ${KEYMAP} == viins ]] ||
			[[ ${KEYMAP} = '' ]] ||
			[[ $1 = 'beam' ]]; then
					echo -ne '\e[6 q'
	fi
}
zle -N zle-keymap-select
precmd_functions+=(zle-keymap-select)

zle-line-init() {
zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
echo -ne "\e[6 q"
}
zle -N zle-line-init

echo -ne '\e[6 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[6 q' ;} # Use beam shape cursor for each new prompt.

##################
# custom keybinds
##################

# Ctrl-f
bindkey -s '^f' "tmux-sessionizer\n"

##########
# plugins
##########

ZSH_AUTOSUGGEST_MANUAL_REBIND=1

source "$ZPLUGINDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$ZPLUGINDIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZPLUGINDIR/powerlevel10k/powerlevel10k.zsh-theme"

source "$ZDOTDIR/.zsh_alias"
[[ -r "$ZDOTDIR/.zsh_local" ]] && source "$ZDOTDIR/.zsh_local"
source "$ZDOTDIR/.p10k.zsh"

# vim: set ts=4 sw=4
