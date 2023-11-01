local wezterm = require "wezterm"

return {
  color_scheme = "Catppuccin Macchiato",
  font = wezterm.font_with_fallback { "JetBrains Mono", { family = "Symbols Nerd Font Mono", scale = 0.75 } },
  font_size = 22,
  hide_tab_bar_if_only_one_tab = true,
  scrollback_lines = 10000,
  use_cap_height_to_scale_fallback_fonts = true,
  window_close_confirmation = "NeverPrompt",
  window_decorations = "RESIZE",
}
