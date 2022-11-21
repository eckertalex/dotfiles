return function(C)
  local catppuccin = require("catppuccin.palettes").get_palette()
  C.telescope_green = catppuccin.green
  C.telescope_red = catppuccin.red
  C.telescope_fg = catppuccin.text
  C.telescope_bg = catppuccin.surface0
  C.telescope_bg_alt = catppuccin.surface1
  return C
end
