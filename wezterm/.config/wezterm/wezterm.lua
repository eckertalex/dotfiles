local wezterm = require("wezterm")

return {
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",
	color_scheme = "Catppuccin Macchiato",
	font = wezterm.font_with_fallback({ "Dank Mono", { family = "Symbols Nerd Font Mono", scale = 0.75 } }),
	use_cap_height_to_scale_fallback_fonts = true,
	font_size = 22,
	scrollback_lines = 10000,
	hide_tab_bar_if_only_one_tab = true,
}
