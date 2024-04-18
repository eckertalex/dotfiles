# !/bin/zsh

function zcompile-many() {
  local f
  for f; do zcompile -R -- "$f".zwc "$f"; done
}

if [[ ! -e $HOME/.config/zsh/plugins/zsh-syntax-highlighting ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.config/zsh/plugins/zsh-syntax-highlighting
  zcompile-many $HOME/.config/zsh/plugins/zsh-syntax-highlighting/{zsh-syntax-highlighting.zsh,highlighters/*/*.zsh}
fi
if [[ ! -e $HOME/.config/zsh/plugins/zsh-autosuggestions ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.config/zsh/plugins/zsh-autosuggestions
  zcompile-many $HOME/.config/zsh/plugins/zsh-autosuggestions/{zsh-autosuggestions.zsh,src/**/*.zsh}
fi
if [[ ! -e $HOME/.config/zsh/plugins/powerlevel10k ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.config/zsh/plugins/powerlevel10k
  make -C $HOME/.config/zsh/plugins/powerlevel10k pkg
fi

#########################
# powerlevel10k
#########################

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
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
source "$HOME/.config/vivid/catppuccin-macchiato.lscolors"
export BAT_THEME="Catppuccin Macchiato"
# Catppuccin Macchiato
export FZF_DEFAULT_OPTS=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

#######
# LIGHT
#######
# source "$HOME/.config/vivid/catppuccin-latte.lscolors"
# export BAT_THEME="Catppuccin Latte"
# # Cattpuccin Latte
# export FZF_DEFAULT_OPTS=" \
# --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
# --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
# --color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"

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

##################
# custom keybinds
##################

# Ctrl-f
bindkey -s '^f' "tmux-sessionizer\n"

#################
# plugins
#################

# Enable the "new" completion system (compsys).
autoload -Uz compinit && compinit
[[ ~/.zcompdump.zwc -nt ~/.zcompdump ]] || zcompile-many ~/.zcompdump
unfunction zcompile-many

ZSH_AUTOSUGGEST_MANUAL_REBIND=1

[[ -s "$HOME/.zsh_local" ]] && source "$HOME/.zsh_local"
source "$HOME/.config/zsh/alias"
source "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.config/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme"
source "$HOME/.p10k.zsh"
