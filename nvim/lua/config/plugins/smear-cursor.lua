-- smear-cursor.nvim — kitty `cursor_trail`-like effect inside nvim, works in
-- any terminal with truecolor + unicode (kitty, ghostty, wezterm).
return {
	"sphamba/smear-cursor.nvim",
	event = "VeryLazy",

	opts = {
		-- When to draw the trail.
		smear_between_buffers = true,
		smear_between_neighbor_lines = true,
		scroll_buffer_space = true,
		smear_insert_mode = true,

		-- NRK Mono doesn't ship the legacy computing symbol block, so keep this
		-- off — flipping it on with an unsupported font produces empty boxes.
		legacy_computing_symbols_support = false,

		-- Trail physics. Lower stiffness/damping = longer, more visible drag.
		-- These values give a noticeable "1.0s" kitty cursor_trail feel without
		-- becoming distracting on fast cursor movement.
		stiffness = 0.5,
		trailing_stiffness = 0.35,
		trailing_exponent = 1.2,
		damping = 0.65,
		matrix_pixel_threshold = 0.4,
		distance_stop_animating = 0.3,

		-- Visual.
		gamma = 2.2,
		cursor_color = "none", -- "none" = use Cursor highlight (theme-driven)

		-- Hides the target glyph until the smear arrives — eliminates a brief
		-- flicker on long jumps in ghostty/wezterm.
		hide_target_hack = true,
	},
}
