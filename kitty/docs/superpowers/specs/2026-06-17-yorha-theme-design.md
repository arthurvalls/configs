# yorha — NieR:Automata theme (kitty + nvim)

**Date:** 2026-06-17
**Status:** implemented

A standalone, switchable colorscheme for nvim + kitty based on the NieR:Automata
**YoRHa menu** aesthetic: warm bone/khaki text on a warm near-black, near-monochrome
with sparse accents. Coexists with `vanta` (active default) and `gruvbox`.

## Decisions

- **Visual mode:** YoRHa menu UI (warm bone-on-black monochrome). Not the ruined-world
  or hacking-minigame readings.
- **Syntax style:** Balanced — bone base, key tokens accented so code stays scannable.
- **Background:** the `assets/yorha.png` wallpaper (2560×1440), `scaled`, **opaque**
  (`background_opacity 1.0`), darkened via `background_tint 0.85`.
  History (all 2026-06-17): started transparent + generated scanline tile →
  opaque (kept scanlines) → replaced scanlines with `yorha.png` + darkened the
  whole palette (bg ramp `#15140f`→`#0f0e0a`). The scanline tile + `make-scanlines.py`
  remain on disk but are no longer referenced.
- **Coexistence:** new theme alongside `vanta`; switch with `:colorscheme yorha`
  (and back with `:colorscheme vanta`). Nothing in `vanta` is modified.

## Palette

```
bg0 #15140f  bg1 #1c1b15  bg2 #21201a  bg3 #2a2820  sel #3a3830
dim #6e6a57  fg  #cdc8ae  fgb #dad5bb  bone+ #e6e1c8
rust #c99b6e (keyword/cursor/accent)   ochre #bfa678 (type)
amber #c9a227 (number/const/warn)      olive #8a8a5c (string)  (#7c8a4e git-add)
red  #c84a3c (error/git-delete)        teal #6fb7b0 (incsearch/matchparen ONLY)
```

## Files

| File | Role |
|------|------|
| `nvim/colors/yorha.lua` | colorscheme (highlights); mirrors `vanta.lua` structure |
| `nvim/lua/config/yorha-lualine.lua` | lualine theme table |
| `nvim/lua/config/plugins/lualine.lua` | **modified**: theme follows colorscheme via `ColorScheme` autocmd |
| `kitty/yorha.conf` | kitty palette + bg opacity/scanlines/tint |
| `kitty/assets/make-scanlines.py` | generator for the scanline tile |
| `kitty/assets/yorha-scanlines.png` | 64×4 faint-scanline tile (generated) |

## Deviations from initial design (discovered while reading the wiring)

- **No `plugins/yorha.lua` / no `plugins.lua` edit.** `plugins/vanta.lua` reuses the
  `gruvbox.nvim` plugin entry; a second copy would be a duplicate spec. The colorscheme
  is auto-discovered from `colors/yorha.lua`, so `:colorscheme yorha` needs no spec.
- **No `terminal-sync.lua` edit.** It already falls back to `~/.config/kitty/<name>.conf`,
  so `yorha` → `yorha.conf` resolves automatically.
- **lualine follow** added via a `ColorScheme` autocmd (the one existing file touched).

## Sync / activation behavior

- `:colorscheme yorha` → `terminal-sync.lua` copies `yorha.conf` to `current-theme.conf`,
  overlays nvim's live Normal/Cursor/Visual, runs `kitty @ set-colors` (palette live),
  and regenerates ghostty/wezterm configs.
- **Caveat:** the scanline background image + opacity apply on kitty **(re)start** only.
  Live `set-colors` swaps palette, not the background image — consistent with the known
  kitty theme-reload limitation in this config. Verify by restarting kitty with `yorha`
  active.

## Not done (optional follow-ups)

- Make `yorha` the startup default (one-line change in `plugins/vanta.lua`).
- Tune scanline density/alpha (`make-scanlines.py`: `PERIOD` / `ALPHA`).

> Note: `~/.config/kitty` is not a git repo, so this doc is not committed.
