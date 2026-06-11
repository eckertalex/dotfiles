# plugin management
function zcompile-many() {
	local f
	for f; do
		zcompile -R -- "$f".zwc "$f";
	done
}

# INFO: I don't want to use ZDOTDIR because it can break when moving to other systems.
# I still want to keep plugins, completions, and zcompdump out of the home directory.
Z_DATA_DIR="$XDG_DATA_HOME/zsh"

Z_PLUGIN_DIR="$Z_DATA_DIR/plugins"
if [[ ! -d "$Z_PLUGIN_DIR/zsh-syntax-highlighting" ]]; then
	git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$Z_PLUGIN_DIR/zsh-syntax-highlighting"
	zcompile-many $Z_PLUGIN_DIR/zsh-syntax-highlighting/{zsh-syntax-highlighting.zsh,highlighters/*/*.zsh}
fi
if [[ ! -d "$Z_PLUGIN_DIR/zsh-autosuggestions" ]]; then
	git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$Z_PLUGIN_DIR/zsh-autosuggestions"
	zcompile-many $Z_PLUGIN_DIR/zsh-autosuggestions/{zsh-autosuggestions.zsh,src/**/*.zsh}
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
HISTFILE="$Z_DATA_DIR/zsh_history"
HISTSIZE=10000
SAVEHIST=10000

# Register the custom completions dir before compinit reads fpath.
fpath=("$Z_DATA_DIR/completions" $fpath)

# theming
source "$XDG_CONFIG_HOME/lscolors/rose-pine-dawn.sh"
source "$XDG_CONFIG_HOME/fzf/rose-pine-dawn.sh"

# mise
if (( $+commands[mise] )); then
	eval "$(mise activate zsh)"
fi

# compinit
# Enable the "new" completion system (compsys).
# Full init (audit + rebuild) at most once a day; fast path (-C) otherwise.
autoload -Uz compinit
if [[ -n "$Z_DATA_DIR/zcompdump"(#qNmh+24) ]]; then
	compinit -d "$Z_DATA_DIR/zcompdump"
else
	compinit -C -d "$Z_DATA_DIR/zcompdump"
fi
[[ "$Z_DATA_DIR/zcompdump.zwc" -nt "$Z_DATA_DIR/zcompdump" ]] || zcompile-many "$Z_DATA_DIR/zcompdump"
unfunction zcompile-many

# fzf
[[ -r "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh" ]] && source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
[[ -r "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh" ]] && source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"

# Ctrl-f
bindkey -s '^f' "tmux-sessionizer\n"

# plugins
source "$Z_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

ZSH_AUTOSUGGEST_MANUAL_REBIND=1
source "$Z_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"

source "$HOME/.zsh_alias"
[[ -r "$HOME/.zsh_local" ]] && source "$HOME/.zsh_local"
source "$HOME/.zsh_vi"
source "$HOME/.zsh_prompt"

# vim: set ts=4 sw=4
