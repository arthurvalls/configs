-- Lualine theme matching colors/gruvbox-ish.lua. Mode pill (section a) carries
-- the accent (aqua normal / green insert / yellow visual / red replace / orange
-- command); b is a warm dark-grey pill; c is transparent so the gruvbox-blur
-- wallpaper shows through. plugins/lualine.lua swaps to this on ColorScheme.
local C = {
  bg = "#1d2021", bg1 = "#282828", bg2 = "#32302f",
  fg_dim = "#a89984", fg = "#dfbf8e",
  aqua = "#689d6a", green = "#8b9553", yellow = "#d69617",
  red = "#d75f5f", orange = "#e78a4e", none = "NONE",
}

local function mode(accent)
  return {
    a = { fg = C.bg, bg = accent, gui = "bold" },
    b = { fg = C.fg, bg = C.bg2 },
    c = { fg = C.fg_dim, bg = C.none },
  }
end

return {
  normal = mode(C.aqua),
  insert = mode(C.green),
  visual = mode(C.yellow),
  replace = mode(C.red),
  command = mode(C.orange),
  inactive = {
    a = { fg = C.fg_dim, bg = C.bg1, gui = "bold" },
    b = { fg = C.fg_dim, bg = C.bg1 },
    c = { fg = C.fg_dim, bg = C.none },
  },
}
