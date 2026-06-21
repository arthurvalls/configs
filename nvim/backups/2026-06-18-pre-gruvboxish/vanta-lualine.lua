-- Lualine theme matching colors/vanta.lua. Only the mode pill (section a)
-- carries the accent; b is a neutral dark-grey pill; c is transparent so the
-- circuit wallpaper shows through the statusline.
local C = {
  bg = "#0a0a0a", bg1 = "#141414", bg2 = "#1a1a1a",
  grey1 = "#6a6a6a", grey2 = "#808080", grey6 = "#c0c0c0",
  teal = "#2ae8c8", teal_br = "#a9ffe8", add = "#7fb07f", del = "#c46b6b",
  cmd = "#bcbcbc", none = "NONE",
}

local function mode(accent)
  return {
    a = { fg = C.bg, bg = accent, gui = "bold" },
    b = { fg = C.grey6, bg = C.bg2 },
    c = { fg = C.grey2, bg = C.none },
  }
end

return {
  normal = mode(C.teal),
  insert = mode(C.add),
  visual = mode(C.teal_br),
  replace = mode(C.del),
  command = mode(C.cmd),
  inactive = {
    a = { fg = C.grey1, bg = C.bg1, gui = "bold" },
    b = { fg = C.grey1, bg = C.bg1 },
    c = { fg = C.grey1, bg = C.none },
  },
}
