-- e-ink (e-ink-colorscheme/e-ink.nvim) — startup colorscheme (greyscale + Everforest accents).
-- The nvim -> kitty sync lives in config/plugins/nightfox.lua; the `e-ink` route
-- resolves to ~/.config/kitty/eink_light.conf or eink_dark.conf based on `vim.o.background`.
-- Falls back to zenbones, then solarized-osaka, if e-ink fails to load.
return {
  "e-ink-colorscheme/e-ink.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.opt.termguicolors = true
    vim.opt.background = "dark"
    require("e-ink").setup()
    if not pcall(vim.cmd, "colorscheme e-ink") then
      if not pcall(vim.cmd, "colorscheme zenbones") then
        pcall(vim.cmd, "colorscheme solarized-osaka")
      end
    end
  end,
}
