# plugin management
function zcompile-many() {
  local f
  for f; do zcompile -R -- "$f".zwc "$f"; done
}

if [[ ! -e "$XDG_DATA_HOME/zsh/plugins/zsh-syntax-highlighting" ]]; then
	git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$XDG_DATA_HOME/zsh/plugins/zsh-syntax-highlighting"
	zcompile-many $XDG_DATA_HOME/zsh/plugins/zsh-syntax-highlighting/{zsh-syntax-highlighting.zsh,highlighters/*/*.zsh}
fi
if [[ ! -e "$XDG_DATA_HOME/zsh/plugins/zsh-autosuggestions" ]]; then
	git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$XDG_DATA_HOME/zsh/plugins/zsh-autosuggestions"
	zcompile-many $XDG_DATA_HOME/zsh/plugins/zsh-autosuggestions/{zsh-autosuggestions.zsh,src/**/*.zsh}
fi

# options
setopt GLOBDOTS
setopt SHARE_HISTORY           # Share history between all sessions (implies incremental append).
setopt HIST_IGNORE_ALL_DUPS    # Delete old entry if new entry is a duplicate (in-memory).
setopt HIST_SAVE_NO_DUPS       # Don't write duplicate entries to the history file.
setopt HIST_FIND_NO_DUPS       # Don't show duplicates when searching (Ctrl+R).
setopt HIST_IGNORE_SPACE       # Don't record entries starting with a space.
setopt HIST_REDUCE_BLANKS      # Remove superfluous blanks from history entries.
unsetopt HIST_VERIFY           # Execute history expansions immediately.

# history
HISTFILE="$XDG_DATA_HOME/zsh/zsh_history"
HISTSIZE=10000
SAVEHIST=10000

# Register the custom completions dir before compinit reads fpath.
fpath=("$XDG_DATA_HOME/zsh/completions"(N-/) $fpath)

# compinit
autoload -Uz compinit && compinit -d "$XDG_DATA_HOME/zsh/zcompdump"
[[ "$XDG_DATA_HOME/zsh/zcompdump.zwc" -nt "$XDG_DATA_HOME/zsh/zcompdump" ]] || zcompile-many "$XDG_DATA_HOME/zsh/zcompdump"
unfunction zcompile-many

# theming
source "$XDG_CONFIG_HOME/lscolors/rose-pine-dawn.sh"
source "$XDG_CONFIG_HOME/fzf/rose-pine-dawn.sh"

# mise
if (( $+commands[mise] )); then
	eval "$(mise activate zsh)"
fi

# fzf
[[ -r "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh" ]] && source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
[[ -r "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh" ]] && source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"

# Ctrl-f
bindkey -s '^f' "tmux-sessionizer\n"

# plugins
source "$XDG_DATA_HOME/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

ZSH_AUTOSUGGEST_MANUAL_REBIND=1
source "$XDG_DATA_HOME/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

source "$HOME/.zsh_alias"
source "$HOME/.zshrc.local"
source "$HOME/.zsh_vi"
source "$HOME/.zsh_prompt"

# vim: set ts=4 sw=4
