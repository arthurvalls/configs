# configs

My personal dotfiles, plus a one-command installer that reproduces the whole
setup on a fresh **Ubuntu/Debian** machine.

## Layout

| Path                                | What it holds                                                          |
| ----------------------------------- | --------------------------------------------------------------------- |
| `nvim/`                             | Neovim config — lazy.nvim, LSP, tokyodark theme                       |
| `kitty/`, `ghostty/`, `wezterm/`, `alacritty/` | Terminal emulator configs                                  |
| `fish/`, `zsh/`, `bash/`            | Shell configs (fish is the daily driver)                              |
| `git/`                              | Global git config                                                     |
| `firefox/`, `zed/`, `java/`, `qtcreator/`, `ideavim/` | App configs                              |
| `iosevka-custom/`, `fonts/`         | Bundled fonts (Iosevka Custom + patched fallbacks)                    |
| `bootstrap.sh`                      | **Fresh-machine installer** — installs tools, then loads the dotfiles |
| `install/`                          | Phase scripts (`NN-name.sh`) + `manifest/` package lists              |
| `test/bootstrap-in-docker.sh`       | Verify the installer in a clean `ubuntu:24.04` container              |
| `copy.sh`                           | Live `$HOME` → repo (stage local changes)                             |
| `load.sh`                           | Repo → live `$HOME` (dotfiles only)                                   |
| `push.sh`                           | `copy.sh` + commit + push in one shot                                 |

## Usage

**Bootstrap a fresh machine** (installs tools *and* dotfiles):

```sh
git clone git@github.com:arthurvalls/configs.git ~/configs
cd ~/configs
./bootstrap.sh                 # terminal env + dev toolchains (default)
```

Useful flags:

```sh
./bootstrap.sh --scope=terminal   # shell/editor/terminal only, no dev toolchains
./bootstrap.sh --dry-run          # print everything it would do, change nothing
./bootstrap.sh --only=10-apt,30-rust
./bootstrap.sh --skip=70-terminals
./bootstrap.sh --yes              # don't prompt
```

Every phase is **idempotent** — re-running skips whatever is already installed.

**Just refresh the dotfiles** (no tool installs):

```sh
./load.sh
```

**Stage local changes back into the repo and push:**

```sh
./push.sh "feat: tweak kitty palette"
```

## What the installer sets up

Phases run in order from `install/` (dev-only phases are skipped with `--scope=terminal`):

| Phase            | Installs                                                                          |
| ---------------- | --------------------------------------------------------------------------------- |
| `00-preflight`   | platform check, sudo, base build deps                                             |
| `10-apt`         | fish, neovim (PPA), wezterm (Fury), gh, fzf, ripgrep, fd, eza, btop, htop, jq, …   |
| `20-brew`        | Linuxbrew + `lazygit`, `glow`                                                      |
| `30-rust` *(dev)*   | rustup + `stylua`, `tinty`                                                      |
| `40-node` *(dev)*   | nvm + Node LTS + corepack (pnpm/yarn) + global npm tools                        |
| `50-langtools` *(dev)* | uv, bun, deno, OpenJDK 21, Maven, Docker                                     |
| `60-cli-extras`  | starship, kitty                                                                   |
| `70-terminals`   | ghostty (community `.deb`, best-effort)                                            |
| `80-fonts`       | bundled fonts (Iosevka Custom + fallbacks) → `fc-cache`                            |
| `90-dotfiles`    | runs `load.sh` (repo → `$HOME`)                                                   |
| `99-shell`       | fish as login shell, fisher, sync `fish_plugins`                                  |

Package lists live in `install/manifest/{apt,brew,cargo,npm}.txt` — edit those to
add or remove tools without touching the phase scripts.

## Highlights

- **Theme**: [tokyodark](https://github.com/tiagovla/tokyodark.nvim) in nvim, mirrored to kitty via `kitty/tokyodark.conf`. On `:colorscheme <name>` inside nvim, a `ColorScheme` autocmd (see `nvim/lua/config/terminal-sync.lua`) copies the matching kitty palette to `~/.config/kitty/current-theme.conf` and calls `kitty @ set-colors` to live-update the active window. The nvim plugin runs with `transparent_background = true` so kitty's blurred background image (`kitty/b-367-blurred.jpg`) shows through.
- **Font**: Iosevka Custom, bundled in `iosevka-custom/` and installed by the `80-fonts` phase (also by `load.sh`).
- **Plugin manager**: [lazy.nvim](https://github.com/folke/lazy.nvim), with a single `lua/config/plugins.lua` aggregating per-plugin spec files.

## Also recommended on a fresh install

### GNOME extensions

- Dash to Panel
- Resource Monitor
- Rounded Window Corners

## Requirements

- Ubuntu/Debian (apt). `bootstrap.sh` bootstraps everything else.
- For the nvim ↔ kitty theme sync: kitty needs `allow_remote_control yes` in `kitty.conf` (already set in this repo).

## Notes

- `packages/` is legacy and superseded by `install/manifest/`. `packages/save.sh`
  is an unrelated leftover (a Docker dev-container launcher) and can be removed.
