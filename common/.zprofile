# prepend user-local binaries
path=("$HOME/.local/bin" $path)

# homebrew
if [[ -d /opt/homebrew ]]; then
    export HOMEBREW_NO_ANALYTICS=1
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# vim: set ts=4 sw=4
