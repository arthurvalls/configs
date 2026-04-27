-- Zenbones (mcchrish/zenbones-theme) — startup colorscheme.
-- The nvim -> kitty sync lives in config/plugins/nightfox.lua; it routes
-- zenbones (dark) and zenbones_light to the matching kitty .conf files in
-- ~/.config/kitty/. Solarized Osaka is preserved in config/plugins/solarized-osaka.lua
-- and can be re-activated via :colorscheme solarized-osaka.
return {
  {
    "rktjmp/lush.nvim",
    lazy = true,
  },
  {
    "zenbones-theme/zenbones.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true
      vim.opt.background = "light"
      if not pcall(vim.cmd, "colorscheme zenbones") then
        pcall(vim.cmd, "colorscheme solarized-osaka")
        return
      end
      -- Pin Normal-family bg to the exact hex used by ~/.config/kitty/zenbones_light.conf
      -- so nvim's editor pane is pixel-identical to kitty's window bg. Lush's HSLuv->sRGB
      -- drifts a few units from shipwright's, which makes nvim read as slightly whiter.
      local bg, fg = "#F0EDEC", "#2C363C"
      local function pin(group, opts)
        vim.api.nvim_set_hl(0, group, opts)
      end
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("ZenbonesBgPin", { clear = true }),
        pattern = "zenbones",
        callback = function()
          pin("Normal", { fg = fg, bg = bg })
          pin("NormalNC", { fg = fg, bg = bg })
          pin("NormalFloat", { fg = fg, bg = bg })
          pin("SignColumn", { bg = bg })
          pin("EndOfBuffer", { fg = bg, bg = bg })
        end,
      })
      vim.cmd.colorscheme("zenbones") -- re-trigger so the autocmd above runs
    end,
  },
}
