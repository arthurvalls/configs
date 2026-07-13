-- ~/.config/nvim/colors/claude_warm.lua
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
	vim.cmd("syntax reset")
end

vim.g.colors_name = "claude_warm"

local palette = {
	bg = "#151413",
	fg = "#d5d1c8",
	dim = "#5e5c58",
	border = "#2a2928",
	sel_bg = "#3a3835",
	sel_fg = "#ece8de",
	orange = "#d38f58",
	cyan = "#80b6c4",
	green = "#8abf7c",
	red = "#cc7874",
	blue = "#7da8c7",
	magenta = "#b38fad",
}

local highlights = {
	-- Base
	Normal = { bg = palette.bg, fg = palette.fg },
	NormalFloat = { bg = palette.border, fg = palette.fg },
	ColorColumn = { bg = palette.border },
	Cursor = { bg = palette.fg, fg = palette.bg },
	CursorLine = { bg = palette.border },
	CursorColumn = { bg = palette.border },
	LineNr = { fg = palette.dim },
	CursorLineNr = { fg = palette.orange, bold = true },
	VertSplit = { fg = palette.sel_bg },
	WinSeparator = { fg = palette.sel_bg },
	SignColumn = { bg = palette.bg },

	-- Search & Selection
	Search = { bg = palette.orange, fg = palette.bg },
	IncSearch = { bg = palette.cyan, fg = palette.bg },
	Visual = { bg = palette.sel_bg },
	VisualNOS = { bg = palette.sel_bg },

	-- Syntax
	Comment = { fg = palette.dim, italic = true },
	String = { fg = palette.green },
	Character = { fg = palette.green },
	Number = { fg = palette.red },
	Boolean = { fg = palette.red },
	Float = { fg = palette.red },

	Identifier = { fg = palette.fg },
	Function = { fg = palette.blue },
	Statement = { fg = palette.orange },
	Conditional = { fg = palette.orange },
	Repeat = { fg = palette.orange },
	Label = { fg = palette.orange },
	Operator = { fg = palette.cyan },
	Keyword = { fg = palette.orange, italic = true },
	Exception = { fg = palette.red },

	PreProc = { fg = palette.magenta },
	Include = { fg = palette.magenta },
	Define = { fg = palette.magenta },
	Macro = { fg = palette.magenta },
	PreCondit = { fg = palette.magenta },

	Type = { fg = palette.cyan },
	StorageClass = { fg = palette.orange },
	Structure = { fg = palette.cyan },
	Typedef = { fg = palette.cyan },

	Special = { fg = palette.magenta },
	SpecialChar = { fg = palette.magenta },
	Tag = { fg = palette.orange },
	Delimiter = { fg = palette.dim },
	SpecialComment = { fg = palette.dim, bold = true },
	Debug = { fg = palette.red },

	Underlined = { underline = true, sp = palette.cyan },
	Ignore = { fg = palette.bg },
	Error = { bg = palette.red, fg = palette.bg, bold = true },
	Todo = { bg = palette.orange, fg = palette.bg, bold = true },

	-- Diagnostics
	DiagnosticError = { fg = palette.red },
	DiagnosticWarn = { fg = palette.orange },
	DiagnosticInfo = { fg = palette.blue },
	DiagnosticHint = { fg = palette.cyan },

	-- Treesitter (Basic overrides, falls back to syntax groups above otherwise)
	["@variable"] = { fg = palette.fg },
	["@property"] = { fg = palette.blue },
	["@function.builtin"] = { fg = palette.cyan },
	["@punctuation.bracket"] = { fg = palette.dim },
}

-- Apply Highlights
for group, settings in pairs(highlights) do
	vim.api.nvim_set_hl(0, group, settings)
end
