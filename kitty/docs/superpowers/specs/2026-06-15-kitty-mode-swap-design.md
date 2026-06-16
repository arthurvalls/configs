# Live-swappable kitty modes: `modern()` / `low-level()`

**Date:** 2026-06-15
**Status:** Approved (pending spec review)

## Goal

Two shell commands that live-swap the whole terminal environment between two
coherent "modes", with no kitty restart:

- **`modern()`** — NRK Mono font, tokyonight-night palette (kitty + nvim),
  cyberpunk background image with baked-in blur + transparency.
- **`low-level()`** — Noto Sans Mono font, gruvbox vantablack palette
  (kitty + nvim), no background image, fully opaque.

Both commands also flip the colorscheme of every running nvim instance so the
editor matches the terminal.

## Confirmed environment (verified 2026-06-15)

- kitty **0.44.0** — supports `kitten @ action load_config_file`.
- `kitty.conf` already has `allow_remote_control yes` and
  `dynamic_background_opacity yes` (live opacity changes work without restart).
- `auto_reload_config yes` is set.
- Fonts installed: **NRK Mono** (`/usr/share/fonts/NRK-Mono-Regular.ttf`) and
  **Noto Sans Mono** (`/usr/share/fonts/truetype/noto/NotoSansMono-Regular.ttf`).
- Current font in use: `NotoSansM Nerd Font Mono` (has Nerd/powerline glyphs —
  used as the symbol fallback below).
- **ImageMagick is NOT installed** — must be installed for the blur pipeline.
- `~/.config/fish/functions/` exists — home for the two new functions.
- nvim has **gruvbox** installed; **tokyonight.nvim is NOT** — must be added.
- `lua/config/terminal-sync.lua` owns `current-theme.conf`: on every
  `:colorscheme`, it copies `~/.config/kitty/<name>.conf` → `current-theme.conf`,
  overlays live highlights, and pushes colors via `kitty @ set-colors`.

## Architecture

`load_config_file` reloads the **entire** default config and resets unspecified
options to defaults, so mode files are **not** passed to it directly (that would
wipe keybinds/etc.). Instead we mirror the existing `current-theme.conf` include
pattern:

1. `kitty.conf` gains one line: `include ./current-mode.conf`.
2. `current-mode.conf` is a **symlink** → `modes/modern.conf` or
   `modes/lowlevel.conf`.
3. A mode command repoints the symlink, then triggers a full reload.

**Colors never travel through reload** (that is the known reload-quirk on this
machine). Colors are pushed live with `kitty @ set-colors` — the same reliable
path `terminal-sync.lua` already uses. Reload carries only **font + background
image + opacity + tint**.

### Division of responsibility

| Concern | Owner | Mechanism |
|---|---|---|
| font_family, background_image, background_opacity, background_tint, symbol_map | mode file | `include current-mode.conf` + reload |
| live kitty palette | mode command | `kitty @ set-colors <palette>.conf` |
| persisted kitty palette | mode command | copy `<palette>.conf` → `current-theme.conf` |
| nvim colorscheme | mode command | remote-send to each nvim socket |

This works whether or not any nvim is running: step 3 sets colors directly, so
the terminal is correct standalone; the nvim broadcast only keeps editors in sync.

## Files

```
~/.config/kitty/
  kitty.conf                      # + include ./current-mode.conf
  current-mode.conf -> modes/...  # symlink (gitignored / runtime state)
  modes/
    modern.conf                   # font + bg (NRK Mono, cyberpunk bg)
    lowlevel.conf                 # font + bg (Noto Sans Mono, none)
    assets/cyberpunk-blur.png     # pre-blurred wallpaper
  gruvbox.conf                    # existing gruvbox palette (low-level colors)
  tokyonight-night.conf           # NEW kitty palette (modern colors)
~/.config/fish/functions/
  modern.fish
  low-level.fish
~/.config/nvim/lua/config/plugins/tokyonight.lua   # NEW plugin spec
~/.config/nvim/lua/config/plugins.lua              # + require tokyonight
```

### `modes/modern.conf` (shape)

```
font_family       NRK Mono
background_image  ~/.config/kitty/modes/assets/cyberpunk-blur.png
background_image_layout scaled
background_opacity 0.85
background_tint   0.55
# Nerd/powerline glyph ranges -> patched Nerd Font fallback
symbol_map U+E0A0-U+E0D7,U+E700-U+E8FF,U+EA60-U+EC1E,U+F000-U+F2FF NotoSansM Nerd Font Mono
```

### `modes/lowlevel.conf` (shape)

```
font_family       Noto Sans Mono
background_opacity 1.0
# background_image intentionally unset; bg color comes from current-theme.conf
symbol_map U+E0A0-U+E0D7,U+E700-U+E8FF,U+EA60-U+EC1E,U+F000-U+F2FF NotoSansM Nerd Font Mono
```

> Exact `symbol_map` ranges to be confirmed against the glyphs bobthefish +
> the Claude status pills actually use, during implementation.

### Fish functions (shape — `modern.fish`)

```fish
function modern --description 'Switch terminal+nvim to modern mode'
    ln -sf modes/modern.conf ~/.config/kitty/current-mode.conf
    kitten @ action load_config_file
    kitty @ set-colors ~/.config/kitty/tokyonight-night.conf
    cp ~/.config/kitty/tokyonight-night.conf ~/.config/kitty/current-theme.conf
    for sock in $XDG_RUNTIME_DIR/nvim.*
        nvim --server $sock --remote-send '<C-\><C-N>:colorscheme tokyonight-night<CR>' 2>/dev/null
    end
end
```

`low-level.fish` is symmetric: `modes/lowlevel.conf`, `gruvbox.conf`,
`:colorscheme gruvbox`.

> Note: copying the palette into `current-theme.conf` races with what
> `terminal-sync.lua` writes when nvim switches; since both write the *same*
> palette for a given mode, they converge. Confirm no visible flicker in
> implementation.

## nvim side

- Add `tokyonight.nvim` plugin spec; default style **night**.
- Wire it into `plugins.lua` (explicit require list — dropping a file in
  `plugins/` is not enough).
- Add `tokyonight-night.conf` kitty palette so `terminal-sync.lua`'s
  `<name>.conf` fallback resolves when the colorscheme is switched manually.

## Background image pipeline (one-time)

1. `sudo apt install imagemagick`.
2. Fetch a permissively-licensed cyberpunk wallpaper (Unsplash license — free
   use, no attribution required).
3. Bake blur + darken once:
   `magick in.jpg -resize 2560x -gaussian-blur 0x14 -modulate 70 modes/assets/cyberpunk-blur.png`
4. Wallpaper is swappable later by re-running step 3 with a new source.

## Decisions

- tokyonight **night** variant (darkest / most cyberpunk).
- Commands **broadcast to all running nvims** (not just the current window's).
- Blur is **baked into the image** (not compositor `background_blur`), so it is
  independent of the compositor.
- Colors via `kitty @ set-colors`, not reload (avoids the known reload-quirk).

## Risks / verify during implementation

1. **Reload must apply font + bg.** No live "set font family" remote command
   exists; font depends on reload applying it. The noted reload-quirk was
   color-specific, so this should hold — verify on-machine before sign-off.
2. **Nerd-Font glyphs** — NRK Mono and Noto Sans Mono lack them; `symbol_map`
   to `NotoSansM Nerd Font Mono` must cover every glyph range the prompt/pills
   use. Verify ranges.
3. **`current-mode.conf` symlink must exist** before the first reload after
   adding the include, or kitty warns on a missing include. Bootstrap it
   pointing at `lowlevel.conf` (current-ish baseline).
```
