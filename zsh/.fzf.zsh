# Setup fzf
# ---------

## Mac
if [[ "$OSTYPE" == "darwin"* ]]; then
	if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  		PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
	fi

	# Auto-completion
	# ---------------
	[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

	# Key bindings
	# ------------
	source "/usr/local/opt/fzf/shell/key-bindings.zsh"
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
	# Auto-completion
	# ---------------
	[[ $- == *i* ]] && source "/usr/share/doc/fzf/examples/completion.zsh" 2> /dev/null

	# Key bindings
	# ------------
	source "/usr/share/doc/fzf/examples/key-bindings.zsh"
fi

