# Declare PATH-like arrays as Unique (-U, dedup) once and early, so every later
# assignment (path_helper, brew shellenv, .zprofile, .zshrc) auto-deduplicates.
# -T ties the INFOPATH scalar to the infopath array (zsh doesn't tie it natively
# the way it does PATH/path, FPATH/fpath, MANPATH/manpath).
export -U PATH path FPATH fpath MANPATH manpath
export -UT INFOPATH infopath

# XDG
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}

# Editors
export EDITOR=nvim
export VISUAL=nvim

# Pager
export PAGER=less
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# vim: set ts=4 sw=4
