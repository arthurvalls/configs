-- Colorscheme → Kitty sync. Mapping from nvim `:colorscheme <name>` to a
-- kitty palette file on disk. Target is always ~/.config/kitty/current-theme.conf
-- (kitty.conf includes it, so new windows persist); we also `kitty @ set-colors`
-- to live-update the active window.
--
-- Requires in kitty.conf: `allow_remote_control yes` and
-- `include current-theme.conf` inside the BEGIN_KITTY_THEME block.

local function nightfox_extra(name)
	return vim.fn.stdpath("data") .. "/lazy/nightfox.nvim/extra/" .. name .. "/kitty.conf"
end

-- Maps colorscheme name → kitty .conf source path.
local sources = {
	nightfox = nightfox_extra("nightfox"),
	dayfox = nightfox_extra("dayfox"),
	dawnfox = nightfox_extra("dawnfox"),
	duskfox = nightfox_extra("duskfox"),
	nordfox = nightfox_extra("nordfox"),
	terafox = nightfox_extra("terafox"),
	carbonfox = nightfox_extra("carbonfox"),
	["solarized-osaka"] = vim.fn.expand("~/.config/kitty/solarized-osaka-kitty.conf"),
}

local function sync_kitty(name)
	local source = sources[name]
	if not source or vim.fn.filereadable(source) == 0 then
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
			group = vim.api.nvim_create_augroup("KittyColorschemeSync", { clear = true }),
			callback = function(args)
				sync_kitty(args.match)
			end,
		})
	end,
}
