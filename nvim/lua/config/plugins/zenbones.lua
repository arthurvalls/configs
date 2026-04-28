-- Zenbones (mcchrish/zenbones-theme) — preserved colorscheme. Startup is now e-ink
-- (see config/plugins/eink.lua). Switch back via `:colorscheme zenbones`.
-- The Normal-bg pin autocmd is registered up-front; it only fires when zenbones
-- is the active colorscheme, so it's safe to leave installed.
return {
  {
    "rktjmp/lush.nvim",
    lazy = true,
  },
  {
    "zenbones-theme/zenbones.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    lazy = false,
    priority = 900,
    config = function()
      -- Pin Normal-family bg to the exact hex used by ~/.config/kitty/zenbones_light.conf
      -- so nvim's editor pane is pixel-identical to kitty's window bg.
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
    end,
  },
}
