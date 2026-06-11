if (( $+commands[brew] )); then
    export HOMEBREW_NO_ANALYTICS=1
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# vim: set ts=4 sw=4
