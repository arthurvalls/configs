-- Lualine theme matching colors/yorha.lua. Only the mode pill (section a)
-- carries the accent (rust normal / olive insert / amber visual / red replace /
-- ochre command); b is a warm dark-grey pill; c is transparent so the scanline
-- wallpaper shows through the statusline. plugins/lualine.lua swaps to this on
-- the ColorScheme event when `yorha` is active.
local C = {
  bg = "#0f0e0a", bg1 = "#15140e", bg2 = "#1a1913",
  grey1 = "#6e6a57", grey2 = "#8a8674", grey6 = "#cdc8ae",
  rust = "#c99b6e", ochre = "#bfa678", amber = "#c9a227",
  olive = "#8a8a5c", red = "#c84a3c", none = "NONE",
}

local function mode(accent)
  return {
    a = { fg = C.bg, bg = accent, gui = "bold" },
    b = { fg = C.grey6, bg = C.bg2 },
    c = { fg = C.grey2, bg = C.none },
  }
end

return {
  normal = mode(C.rust),
  insert = mode(C.olive),
  visual = mode(C.amber),
  replace = mode(C.red),
  command = mode(C.ochre),
  inactive = {
    a = { fg = C.grey1, bg = C.bg1, gui = "bold" },
    b = { fg = C.grey1, bg = C.bg1 },
    c = { fg = C.grey1, bg = C.none },
  },
}
