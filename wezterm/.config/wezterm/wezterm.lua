local wezterm = require("wezterm")

local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "rose-pine-moon"
	else
		return "rose-pine-dawn"
	end
end

return {
	color_scheme = scheme_for_appearance(get_appearance()),
	font_size = 20,
	hide_tab_bar_if_only_one_tab = true,
	scrollback_lines = 10000,
	use_cap_height_to_scale_fallback_fonts = true,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",
}
