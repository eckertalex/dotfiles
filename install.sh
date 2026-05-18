#!/usr/bin/env bash

set -euo pipefail

echo "Stowing common..."
stow -R common

case "$(uname -s)" in
    Darwin)
        echo "Stowing mac..."
        stow -R mac
        ;;
    *)
        echo "Unsupported OS: $(uname -s)" >&2
        exit 1
        ;;
esac

echo "Done."
