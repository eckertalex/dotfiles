#!/usr/bin/env bash

set -euo pipefail

# create these first so stow doesn't symlink the whole folder and tools dump
# untracked files in here. not needed for nvim, it doesn't write garbage there
mkdir -p ~/.config ~/.config/lazygit ~/.local ~/.local/bin

echo "Stowing common..."
stow -R common

case "$(uname -s)" in
    Darwin)
        echo "Stowing mac..."
        stow -R mac
        ;;
    Linux)
        echo "Stowing linux..."
        stow -R linux
        ;;
    *)
        echo "Unsupported OS: $(uname -s)" >&2
        exit 1
        ;;
esac

echo "Done."
