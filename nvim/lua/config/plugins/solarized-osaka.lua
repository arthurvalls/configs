-- Solarized Osaka (craftzdog) — the startup colorscheme.
-- The nvim -> kitty sync lives in config/plugins/nightfox.lua; it routes this
-- colorscheme to ~/.config/kitty/solarized-osaka-kitty.conf.
return {
  "craftzdog/solarized-osaka.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    transparent = false,
    styles = {
      comments = { italic = true },
      keywords = { italic = false, bold = true },
      functions = {},
      variables = {},
    },
    -- Keep palette in sync with ~/.config/kitty/solarized-osaka-kitty.conf.
    on_colors = function(colors)
      colors.bg = "#00080c"
      colors.bg_dark = "#00060a"
      colors.bg_highlight = "#002029"
      colors.fg = "#cfdada"
      colors.fg_dark = "#b3bfbf"
    end,
  },
  config = function(_, opts)
    require("solarized-osaka").setup(opts)
    if not pcall(vim.cmd, "colorscheme solarized-osaka") then
      pcall(vim.cmd, "colorscheme carbonfox")
    end
  end,
}
