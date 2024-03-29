# !/bin/zsh

#########################
# zcomet & powerlevel10k
#########################

if [[ ! -e $HOME/.zcomet/bin ]]; then
	git clone --depth=1 https://github.com/agkozak/zcomet.git $HOME/.zcomet/bin
fi

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source "$HOME/.zcomet/bin/zcomet.zsh"

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

HISTSIZE=50000
SAVEHIST=50000

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export PAGER=less
export EDITOR=nvim
export VISUAL=nvim

# -U ensures each entry in these is Unique (that is, discards duplicates)
# -T creates a "tied" pair
export -U PATH path FPATH fpath MANPATH manpath
export -UT INFOPATH infopath
PATH=$HOME/.config/zsh/functions:$HOME/.local/bin:$PATH
FPATH=$HOME/.config/zsh/completions:$FPATH
source "$HOME/.config/zsh/pnpm.zsh"

##########
# Wezterm
##########

PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"

############
# Homebrew
############

export HOMEBREW_NO_ANALYTICS=1
case $OSTYPE in
	linux*)
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
		;;
	darwin*)
		eval "$(/opt/homebrew/bin/brew shellenv)"
		;;
esac

if type brew &> /dev/null; then
	PATH=$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH
	FPATH=$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH
fi

#####
# FZF
#####

# Auto-completion
[ -s "/opt/homebrew/opt/fzf/shell/completion.zsh" ] && source "/opt/homebrew/opt/fzf/shell/completion.zsh"
# Key bindings
[ -s "/opt/homebrew/opt/fzf/shell/key-bindings.zsh" ] && source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"

export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"

#########
# THEMING
#########

######
# DARK
######
source "$HOME/.config/vivid/tokyonight-night.lscolors"
export BAT_THEME="tokyonight_night"
# Tokyo Night Night
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
	--color=fg:#c0caf5,bg:#1a1b26,hl:#ff9e64 \
	--color=fg+:#c0caf5,bg+:#292e42,hl+:#ff9e64 \
	--color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff \
	--color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a"

#######
# LIGHT
#######
# source "$HOME/.config/vivid/tokyonight-day.lscolors"
# export BAT_THEME="tokyonight_day"
# # Tokyo Night Day
# export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
# 	--color=fg:#3760bf,bg:#e1e2e7,hl:#b15c00 \
# 	--color=fg+:#3760bf,bg+:#c4c8da,hl+:#b15c00 \
# 	--color=info:#2e7de9,prompt:#007197,pointer:#007197 \
# 	--color=marker:#587539,spinner:#587539,header:#587539"

###########
# bob/nvim
###########

if type bob &> /dev/null; then
	PATH=$HOME/.local/share/bob/nvim-bin:$PATH
fi

#######
# asdf
#######

[ -s "$HOME/.asdf/asdf.sh" ] && source "$HOME/.asdf/asdf.sh"
[ -s "$HOME/.asdf/plugins/golang/set-env.zsh" ] && source "$HOME/.asdf/plugins/golang/set-env.zsh"
FPATH=$ASDF_DIR/completions:$FPATH

#################
# plugins
#################

ZSH_AUTOSUGGEST_MANUAL_REBIND=1

[[ -s "$HOME/.zsh_local" ]] && source "$HOME/.zsh_local"

zcomet load zsh-users/zsh-syntax-highlighting
zcomet load zsh-users/zsh-autosuggestions
zcomet load romkatv/powerlevel10k

##########
# aliases
##########

source "$HOME/.config/zsh/alias"

##################
# custom keybinds
##################

# Ctrl-f
bindkey -s '^f' "tmux-sessionizer\n"

################

zcomet compinit
source "$HOME/.p10k.zsh"
