# prepend user-local binaries
path=("$HOME/.local/bin"(N-/) $path)

# homebrew
if [[ -e "/opt/homebrew" ]]; then
    export HOMEBREW_NO_ANALYTICS=1
    # `brew shellenv`, hardcoded to skip running brew on every login shell
    export HOMEBREW_PREFIX="/opt/homebrew"
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
    export HOMEBREW_REPOSITORY="/opt/homebrew"
    path=("/opt/homebrew/bin" "/opt/homebrew/sbin" $path)
    fpath=("/opt/homebrew/share/zsh/site-functions" $fpath)
    infopath=("/opt/homebrew/share/info" $infopath)
fi

# vim: set ts=4 sw=4
