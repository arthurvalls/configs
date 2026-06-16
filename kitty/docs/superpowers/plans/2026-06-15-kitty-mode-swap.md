# Live-swappable kitty modes (`modern` / `low-level`) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Two fish commands, `modern` and `low-level`, that live-swap kitty (font + background + colors) and all running nvim instances' colorscheme between a tokyonight-night cyberpunk mode and a gruvbox-vantablack mode, with no kitty restart.

**Architecture:** A `current-mode.conf` symlink (included by `kitty.conf`) points at one of two mode files that carry only font + background settings. Each fish command repoints the symlink, reloads kitty (`kitten @ action load_config_file`), pushes the matching palette live via `kitty @ set-colors` (the reliable path — reload is *not* trusted for colors on this machine), persists that palette to `current-theme.conf`, then remote-sends `:colorscheme` to every nvim socket. Colors are owned by `set-colors` + the existing `terminal-sync.lua`; mode files own font + bg image + opacity + tint + symbol_map.

**Tech Stack:** kitty 0.44 remote control, fish functions, lazy.nvim (tokyonight.nvim), ImageMagick (one-time blur bake).

**Note on version control:** `~/.config/kitty` is not a git repo. Per-task "commit" steps are therefore replaced with verification checkpoints. If you want history, run `git init` here first and commit after each task — otherwise proceed without.

---

## File Structure

| Path | Responsibility |
|---|---|
| `~/.config/kitty/tokyonight-night.conf` | tokyonight-night kitty palette (colors only) — also resolves `terminal-sync.lua`'s `<name>.conf` fallback |
| `~/.config/kitty/modes/modern.conf` | modern mode: NRK Mono, cyberpunk bg, opacity, tint, symbol_map |
| `~/.config/kitty/modes/lowlevel.conf` | low-level mode: Noto Sans Mono, opaque, symbol_map |
| `~/.config/kitty/modes/assets/cyberpunk-blur.png` | pre-blurred background image |
| `~/.config/kitty/current-mode.conf` | symlink → active mode file (runtime state) |
| `~/.config/kitty/kitty.conf` | + `include ./current-mode.conf` after the theme block |
| `~/.config/fish/functions/modern.fish` | `modern` command |
| `~/.config/fish/functions/low-level.fish` | `low-level` command |
| `~/.config/nvim/lua/config/plugins/tokyonight.lua` | tokyonight.nvim spec (style=night, no startup colorscheme) |
| `~/.config/nvim/lua/config/plugins.lua` | + `require("config.plugins.tokyonight")` |

---

## Task 1: tokyonight-night kitty palette

**Files:**
- Create: `~/.config/kitty/tokyonight-night.conf`

- [ ] **Step 1: Write the palette file**

```conf
# vim:ft=kitty
# name:  Tokyo Night (Night)
# Canonical folke/tokyonight.nvim "night" palette. Colors only — font and
# background live in modes/modern.conf. Filename matches the nvim colorscheme
# name so terminal-sync.lua's <name>.conf fallback resolves it.

foreground            #c0caf5
background            #1a1b26
selection_foreground  #c0caf5
selection_background  #283457
cursor                #c0caf5
cursor_text_color     #1a1b26
url_color             #73daca

active_border_color   #29a4bd
inactive_border_color #292e42

# normal
color0 #15161e
color1 #f7768e
color2 #9ece6a
color3 #e0af68
color4 #7aa2f7
color5 #bb9af7
color6 #7dcfff
color7 #a9b1d6

# bright
color8  #414868
color9  #f7768e
color10 #9ece6a
color11 #e0af68
color12 #7aa2f7
color13 #bb9af7
color14 #7dcfff
color15 #c0caf5
```

- [ ] **Step 2: Verify kitty can parse it (no errors)**

Run: `kitty +runpy "import sys; from kitty.config import parse_config; parse_config(open(sys.argv[-1]).readlines()); print('OK')" ~/.config/kitty/tokyonight-night.conf`
Expected: prints `OK` with no traceback. (If `+runpy` is unavailable on this build, instead run `kitty @ set-colors --dry-run ~/.config/kitty/tokyonight-night.conf` and expect no error output.)

- [ ] **Step 3: Checkpoint**

Confirm the file exists: `test -f ~/.config/kitty/tokyonight-night.conf && echo present`. Expected: `present`.

---

## Task 2: Cyberpunk background image (blur baked in) — Pillow, no ImageMagick

**Decision change (2026-06-15):** ImageMagick is unavailable and passwordless
sudo isn't either. Per user request, blur with a **Python/Pillow** script
instead. Pillow 10.2.0 + Python 3.12.3 are already installed; no install needed.

**Files:**
- Create: `~/.config/kitty/modes/assets/blur-bg.py` (reusable blur/darken/crop tool)
- Create: `~/.config/kitty/modes/assets/cyberpunk-blur.png` (the output)

- [ ] **Step 1: Create the assets directory**

Run: `mkdir -p ~/.config/kitty/modes/assets`
Expected: exit 0. (Already created.)

- [ ] **Step 2: Write the reusable Pillow blur script**

`blur-bg.py` takes a source image, crops-to-fill 2560x1440, applies a Gaussian
blur and a brightness reduction, and writes a PNG. If no source is given (or it
fails to open) it generates a procedural neon-gradient background so the task
always produces an output. See the file content committed in this task.

- [ ] **Step 3: Source a cyberpunk wallpaper (verification-gated)**

Use WebSearch / curl to fetch a permissively-licensed (Unsplash/CC0) cyberpunk
city-neon wallpaper to `/tmp/cyberpunk-src.jpg`, then verify it opens in Pillow:
```bash
python3 -c "from PIL import Image; Image.open('/tmp/cyberpunk-src.jpg').verify(); print('SRC_OK')"
```
Expected: `SRC_OK`. If no valid download is possible, skip the source arg in
Step 4 — the script falls back to the procedural generator.

- [ ] **Step 4: Bake the asset**

Run: `python3 ~/.config/kitty/modes/assets/blur-bg.py /tmp/cyberpunk-src.jpg ~/.config/kitty/modes/assets/cyberpunk-blur.png`
(Omit the first path argument to force procedural generation.)
Expected: prints `WROTE <path> (2560x1440)`.

- [ ] **Step 5: Verify the asset is a valid PNG of the right size**

Run: `python3 -c "from PIL import Image; im=Image.open('$HOME/.config/kitty/modes/assets/cyberpunk-blur.png'); print('OK', im.format, im.size)"`
Expected: `OK PNG (2560, 1440)`.

---

## Task 3: Mode files (font + background only)

**Files:**
- Create: `~/.config/kitty/modes/modern.conf`
- Create: `~/.config/kitty/modes/lowlevel.conf`

- [ ] **Step 1: Write `modes/modern.conf`**

```conf
# vim:ft=kitty
# MODERN mode — font + background only (colors set live by `modern` via set-colors).
# Included after the theme block in kitty.conf, so these override the defaults
# set near the top of kitty.conf.

font_family        NRK Mono

background_image        /home/arthur/.config/kitty/modes/assets/cyberpunk-blur.png
background_image_layout scaled
background_opacity      0.85
background_tint         0.55

# NRK Mono has no Nerd/powerline glyphs; route icon ranges to the installed
# patched font so the bobthefish prompt + Claude status pills still render.
symbol_map U+23FB-U+23FE,U+2665,U+26A1,U+2B58,U+E000-U+E00A,U+E0A0-U+E0A3,U+E0B0-U+E0C8,U+E0CA,U+E0CC-U+E0D7,U+E200-U+E2A9,U+E300-U+E3E3,U+E5FA-U+E6B7,U+E700-U+E8EF,U+EA60-U+EC1E,U+ED00-U+EFCE,U+F000-U+F2FF,U+F300-U+F381,U+F400-U+F533 NotoSansM Nerd Font Mono
```

- [ ] **Step 2: Write `modes/lowlevel.conf`**

```conf
# vim:ft=kitty
# LOW-LEVEL mode — font + background only (colors set live by `low-level`).
# No background image; fully opaque gruvbox vantablack.

font_family        Noto Sans Mono

background_opacity 1.0
# background_image intentionally unset (cleared on reload). bg color comes from
# current-theme.conf (gruvbox vantablack).

symbol_map U+23FB-U+23FE,U+2665,U+26A1,U+2B58,U+E000-U+E00A,U+E0A0-U+E0A3,U+E0B0-U+E0C8,U+E0CA,U+E0CC-U+E0D7,U+E200-U+E2A9,U+E300-U+E3E3,U+E5FA-U+E6B7,U+E700-U+E8EF,U+EA60-U+EC1E,U+ED00-U+EFCE,U+F000-U+F2FF,U+F300-U+F381,U+F400-U+F533 NotoSansM Nerd Font Mono
```

- [ ] **Step 3: Verify both fonts resolve to real files**

Run: `fc-match "NRK Mono" && fc-match "Noto Sans Mono"`
Expected: first line resolves to an `NRK-Mono-*.ttf`, second to `NotoSansMono-Regular.ttf` (NOT a substitute family — if either prints an unrelated family, the font name is wrong).

---

## Task 4: Wire the include + bootstrap the symlink

**Files:**
- Modify: `~/.config/kitty/kitty.conf` (after line 91, the `# END_KITTY_THEME` line)
- Create: `~/.config/kitty/current-mode.conf` (symlink)

- [ ] **Step 1: Bootstrap the symlink to low-level (current baseline)**

Run: `ln -sf modes/lowlevel.conf ~/.config/kitty/current-mode.conf`
Expected: `readlink ~/.config/kitty/current-mode.conf` prints `modes/lowlevel.conf`.

- [ ] **Step 2: Add the include to `kitty.conf`**

Insert immediately after the `# END_KITTY_THEME` line (currently line 91), before the commented `# include ./gumshoe.conf`:

```conf

# Mode overlay (font + background) — driven by `modern` / `low-level` fish
# commands which repoint this symlink and reload. MUST come after the theme
# block so mode font/opacity override the defaults set at the top of this file.
include ./current-mode.conf
```

- [ ] **Step 3: Verify the whole config parses and reloads cleanly**

Run: `kitten @ action load_config_file; echo "exit=$status"`
Expected: `exit=0` and no error popup in kitty. (`$status` is fish syntax; in bash use `$?`.)

- [ ] **Step 4: Checkpoint — confirm low-level font took effect**

Visually confirm the active window now renders in Noto Sans Mono and the prompt's powerline/Nerd glyphs are still intact (symbol_map working). If glyphs are broken (tofu), the `symbol_map` ranges need adjustment — note which glyph and widen the range.

---

## Task 5: tokyonight.nvim plugin + loader wiring

**Files:**
- Create: `~/.config/nvim/lua/config/plugins/tokyonight.lua`
- Modify: `~/.config/nvim/lua/config/plugins.lua`

- [ ] **Step 1: Write the plugin spec**

```lua
-- tokyonight (folke/tokyonight.nvim), "night" style — the modern-mode editor theme.
--
-- Does NOT call vim.cmd.colorscheme at startup (priority below gruvbox's 1000),
-- so gruvbox stays the boot default; `:colorscheme tokyonight-night` is invoked
-- on demand by the `modern` fish command via nvim remote-send.
--
-- terminal_colors = false mirrors the gruvbox spec: terminal-sync.lua then keeps
-- the canonical ANSI from ~/.config/kitty/tokyonight-night.conf (the <name>.conf
-- fallback) instead of nvim-exported terminal_color_*, while still overlaying the
-- live Normal bg/fg + cursor + selection.

return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 999,
	opts = {
		style = "night",
		terminal_colors = false,
	},
}
```

- [ ] **Step 2: Register it in the loader**

In `~/.config/nvim/lua/config/plugins.lua`, add this line right after the `require("config.plugins.gruvbox"),` line:

```lua
	require("config.plugins.tokyonight"),
```

- [ ] **Step 3: Install the plugin headlessly**

Run: `nvim --headless "+Lazy! sync" +qa 2>&1 | tail -5`
Expected: completes without error; tokyonight.nvim appears installed (no `not found` / error lines).

- [ ] **Step 4: Verify the colorscheme loads and gruvbox is still default**

Run: `nvim --headless "+lua vim.cmd.colorscheme('tokyonight-night'); print(vim.g.colors_name)" +qa 2>&1 | tail -2`
Expected: prints `tokyonight-night` with no error.
Run: `nvim --headless "+lua print(vim.g.colors_name)" +qa 2>&1 | tail -2`
Expected: prints `gruvbox` (startup default unchanged).

---

## Task 6: The two fish functions

**Files:**
- Create: `~/.config/fish/functions/modern.fish`
- Create: `~/.config/fish/functions/low-level.fish`

- [ ] **Step 1: Write `modern.fish`**

```fish
function modern --description 'Switch terminal + all nvims to modern mode (tokyonight-night, cyberpunk bg, NRK Mono)'
    set -l kdir ~/.config/kitty
    # 1. Repoint the mode overlay and reload kitty (applies font + bg live).
    ln -sf modes/modern.conf $kdir/current-mode.conf
    kitten @ action load_config_file
    # 2. Push colors live (reliable path) and persist them for future reloads.
    kitty @ set-colors $kdir/tokyonight-night.conf
    cp $kdir/tokyonight-night.conf $kdir/current-theme.conf
    # 3. Flip every running nvim to the matching colorscheme.
    for sock in $XDG_RUNTIME_DIR/nvim.*
        test -S $sock; and nvim --server $sock --remote-send '<C-\><C-N>:colorscheme tokyonight-night<CR>' 2>/dev/null
    end
end
```

- [ ] **Step 2: Write `low-level.fish`**

```fish
function low-level --description 'Switch terminal + all nvims to low-level mode (gruvbox vantablack, Noto Sans Mono, no bg)'
    set -l kdir ~/.config/kitty
    # 1. Repoint the mode overlay and reload kitty (clears bg image, sets font).
    ln -sf modes/lowlevel.conf $kdir/current-mode.conf
    kitten @ action load_config_file
    # 2. Push gruvbox palette live and persist it.
    kitty @ set-colors $kdir/gruvbox.conf
    cp $kdir/gruvbox.conf $kdir/current-theme.conf
    # 3. Flip every running nvim back to gruvbox.
    for sock in $XDG_RUNTIME_DIR/nvim.*
        test -S $sock; and nvim --server $sock --remote-send '<C-\><C-N>:colorscheme gruvbox<CR>' 2>/dev/null
    end
end
```

- [ ] **Step 3: Verify fish loads both functions without syntax error**

Run: `fish -c 'functions -q modern; and functions -q low-level; and echo BOTH_OK'`
Expected: `BOTH_OK`. (Autoloaded from `~/.config/fish/functions/`; no sourcing needed.)

---

## Task 7: End-to-end verification

No new files. Confirms the full swap works both directions.

- [ ] **Step 1: Run `modern` and verify kitty colors switched**

Run: `fish -c modern; and kitty @ get-colors | grep -E '^background '`
Expected: `background #1a1b26` (tokyonight). Visually: cyberpunk image visible through ~85% opacity, NRK Mono active, prompt glyphs intact.

- [ ] **Step 2: Verify the modern background image is applied**

Run: `kitty @ get-colors >/dev/null; readlink ~/.config/kitty/current-mode.conf`
Expected: `modes/modern.conf`. Visually confirm the blurred wallpaper is showing and text is readable over the tint.

- [ ] **Step 3: Verify a running nvim flipped to tokyonight-night**

Open an nvim in another kitty window first, then re-run `fish -c modern`. In that nvim run `:echo g:colors_name`.
Expected: `tokyonight-night`. The kitty window's colors should match the editor.

- [ ] **Step 4: Run `low-level` and verify the revert**

Run: `fish -c low-level; and kitty @ get-colors | grep -E '^background '`
Expected: `background #0a0a0a` (gruvbox vantablack). Visually: no background image, fully opaque, Noto Sans Mono active, glyphs intact. The nvim from Step 3 shows `:echo g:colors_name` → `gruvbox`.

- [ ] **Step 5: Verify no-nvim case**

With no nvim running, run `fish -c modern` then `fish -c low-level`. Each must still switch kitty font/bg/colors correctly (the loop over sockets is a no-op). Confirm `kitty @ get-colors` background matches the mode each time.

- [ ] **Step 6: Confirm font swap survived reload (risk #2 from spec)**

After Step 4, confirm the font actually changed to Noto Sans Mono (not stuck on NRK Mono from the previous mode). If the font did NOT change on reload, the reload-applies-font assumption failed — fall back to documenting that a font swap needs `kitty @ action load_config_file` twice, or investigate the reload quirk further before sign-off.
```
