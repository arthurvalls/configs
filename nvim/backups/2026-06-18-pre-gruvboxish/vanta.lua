-- Activates the standalone startup colorscheme `yorha` (NieR:Automata YoRHa
-- menu — ~/.config/nvim/colors/yorha.lua). `vanta` (colors/vanta.lua) stays
-- available via `:colorscheme vanta`. Both are auto-discovered; this spec just
-- applies the default at startup (lazy=false, priority=1000, before other
-- plugins render).
--
-- We keep gruvbox.nvim INSTALLED as a fallback colorscheme (`:colorscheme
-- gruvbox` still works), but it is no longer the active theme. The recolored
-- gruvbox-vantablack build is preserved at:
--   ~/.config/nvim/lua/config/plugins/gruvbox.lua            (inert, not required)
--   ~/.config/nvim/lua/config/plugins/gruvbox.lua.vantablack-built.bak
--   ~/.config/kitty/gruvbox.conf(.vantablack-built.bak)
--
-- terminal-sync.lua mirrors the palette to kitty via ~/.config/kitty/yorha.conf
-- (resolved by colorscheme name) on the ColorScheme event.
return {
  "ellisonleao/gruvbox.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("yorha")
  end,
}
