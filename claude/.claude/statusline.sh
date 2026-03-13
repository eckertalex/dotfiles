#!/bin/sh
# Claude Code statusline
# Reads JSON from stdin, caches git branch in /tmp for instant rendering.
input=$(cat)

# --- Extract fields ---
model=$(echo "$input" | jq -r '.model.display_name // ""')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // empty')

# --- Project folder (basename) ---
project="${cwd##*/}"

# --- Git branch (cached 5s in /tmp) ---
branch=""
if [ -n "$cwd" ]; then
  cache_key=$(printf '%s' "$cwd" | md5 2>/dev/null || printf '%s' "$cwd" | md5sum 2>/dev/null | cut -d' ' -f1)
  cache_file="/tmp/claude-sl-git-${cache_key}"
  now=$(date +%s)

  if [ -f "$cache_file" ]; then
    cached_time=$(head -1 "$cache_file")
    age=$((now - cached_time))
    if [ "$age" -lt 5 ]; then
      branch=$(tail -1 "$cache_file")
    fi
  fi

  if [ -z "$branch" ] || [ "${age:-999}" -ge 5 ]; then
    if git_branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null); then
      branch="$git_branch"
    elif git_branch=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null); then
      branch="$git_branch"
    fi
    printf '%s\n%s' "$now" "$branch" > "$cache_file" 2>/dev/null
  fi
fi

# --- Helpers ---
fmt_tokens() {
  awk "BEGIN {
    t = $1
    if (t >= 1000000) printf \"%.1fM\", t / 1000000
    else if (t >= 1000) printf \"%.0fk\", t / 1000
    else printf \"%d\", t
  }"
}

fmt_duration() {
  secs=$(($1 / 1000))
  if [ "$secs" -ge 3600 ]; then
    printf "%dh %dm" $((secs / 3600)) $(( (secs % 3600) / 60 ))
  elif [ "$secs" -ge 60 ]; then
    printf "%dm %ds" $((secs / 60)) $((secs % 60))
  else
    printf "%ds" "$secs"
  fi
}

# --- Line 1: Model | project · branch ---
if [ -n "$model" ]; then
  case "$model" in
    *Opus*)  model_color="\033[38;5;135m" ;;  # purple
    *Haiku*) model_color="\033[32m" ;;         # green
    *)       model_color="\033[38;5;208m" ;;   # orange (Sonnet, default)
  esac
  printf "${model_color}%s\033[0m" "$model"
fi

if [ -n "$project" ]; then
  printf " \033[2m|\033[0m \033[36m%s\033[0m" "$project"
fi

if [ -n "$branch" ]; then
  printf " \033[2m·\033[0m \033[35m%s\033[0m" "$branch"
fi

# --- Tail: cost · ctx N% (used/total) ---
tail=""

if [ -n "$cost" ] && [ "$cost" != "0" ]; then
  formatted_cost=$(printf "\$%.2f" "$cost")
  tail="\033[2m${formatted_cost}\033[0m"
fi

if [ -n "$ctx_pct" ] && [ -n "$ctx_size" ]; then
  ctx_int=$(printf "%.0f" "$ctx_pct")
  used_tokens=$(awk "BEGIN { printf \"%.0f\", $ctx_size * $ctx_pct / 100 }")
  used_fmt=$(fmt_tokens "$used_tokens")
  total_fmt=$(fmt_tokens "$ctx_size")

  if [ "$ctx_int" -ge 80 ]; then
    color="\033[31m"
  elif [ "$ctx_int" -ge 50 ]; then
    color="\033[33m"
  else
    color="\033[32m"
  fi

  ctx_str="${color}ctx ${ctx_int}% (${used_fmt}/${total_fmt})\033[0m"

  if [ -n "$tail" ]; then
    tail="${tail} \033[2m·\033[0m ${ctx_str}"
  else
    tail="${ctx_str}"
  fi
fi

if [ -n "$tail" ]; then
  printf " \033[2m|\033[0m %b" "$tail"
fi

printf "\n"
