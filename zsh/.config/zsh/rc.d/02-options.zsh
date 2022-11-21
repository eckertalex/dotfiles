#!/bin/zsh

setopt EXTENDED_HISTORY         # Save time stamps and durations
setopt HIST_SAVE_NO_DUPS        # When writing out the history file, older commands that duplicate newer ones are omitted. 
setopt HIST_EXPIRE_DUPS_FIRST   # Expire duplicates first
setopt HIST_FCNTL_LOCK          # Use modern file-locking mechanisms, for better safety & performance.
setopt HIST_IGNORE_ALL_DUPS     # Keep only the most recent copy of each duplicate entry in history.
setopt SHARE_HISTORY            # Auto-sync history between concurrent sessions.
setopt NO_CLOBBER               # Don't let > overwrite files. To overwrite, use >| instead.
setopt INTERACTIVE_COMMENTS     # Allow comments to be pasted into the command line.
setopt HASH_EXECUTABLES_ONLY    # Don't treat non-executable files in your $path as commands.
setopt EXTENDED_GLOB            # Enable additional glob operators. (Globbing = pattern matching)
setopt GLOB_STAR_SHORT          # Enable ** and *** as shortcuts for **/* and ***/*, respectively.
setopt NUMERIC_GLOB_SORT        # Sort numbers numerically, not lexicographically.
setopt NO_MENU_COMPLETE         # do not autoselect the first completion entry
setopt GLOB_DOTS                # Do not require a leading ‘.’ in a filename to be matched explicitly. 
setopt GLOB_STAR_SHORT          # the pattern ‘**/*’ can be abbreviated to ‘**’ and the pattern ‘***/*’ can be abbreviated to ***
# Change dirs without `cd`. Just type the dir and press enter.
# NOTE: This will misfire if there is an alias, function, builtin or command
# with the same name!
# To be safe, use autocd only with paths starting with .. or / or ~ (including
# named directories).
setopt AUTO_CD
