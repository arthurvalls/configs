-- Nightfox + Kitty colorscheme sync.
--
-- Flow on `:colorscheme <variant>`:
--   1. Read the shipped kitty conf from the plugin's extra/<variant>/kitty.conf.
--   2. Copy it to ~/.config/kitty/current-theme.conf so new windows persist.
--   3. Call `kitty @ set-colors -c <path>` to live-update the current window.
--
-- Requires in kitty.conf: `allow_remote_control yes` and
-- `include current-theme.conf` inside the BEGIN_KITTY_THEME block.

local variants = {
  nightfox = true,
  dayfox = true,
  dawnfox = true,
  duskfox = true,
  nordfox = true,
  terafox = true,
  carbonfox = true,
}

local function shipped_kitty_conf(name)
  local plugin = vim.fn.stdpath("data") .. "/lazy/nightfox.nvim"
  return plugin .. "/extra/" .. name .. "/kitty.conf"
end

local function sync_kitty(name)
  if not variants[name] then
    return
  end
  local source = shipped_kitty_conf(name)
  if vim.fn.filereadable(source) == 0 then
    return
  end
  local target = vim.fn.expand("~/.config/kitty/current-theme.conf")
  vim.fn.system({ "cp", source, target })
  vim.fn.jobstart({ "kitty", "@", "set-colors", "-c", target }, { detach = true })
end

return {
  "EdenEast/nightfox.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("nightfox").setup({
      options = {
        terminal_colors = true,
        styles = {
          comments = "italic",
          keywords = "bold",
        },
      },
    })

    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("NightfoxKittySync", { clear = true }),
      callback = function(args)
        sync_kitty(args.match)
      end,
    })

    vim.cmd("colorscheme carbonfox")
  end,
}
