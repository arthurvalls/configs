# configs

My personal dotfiles. A snapshot of the tools I run daily on Linux.

## Layout

| Path                       | What it holds                                                         |
| -------------------------- | --------------------------------------------------------------------- |
| `nvim/`                    | Neovim config — lazy.nvim, LSP, themes (nightfox, solarized-osaka)    |
| `kitty/`                   | Kitty terminal — `kitty.conf`, theme palettes, `current-theme.conf`   |
| `alacritty/`               | Alacritty config (+ `.tmux.conf`)                                     |
| `fish/`, `zsh/`, `bash/`   | Shell configs                                                         |
| `git/`                     | Global git config                                                     |
| `firefox/`, `zed/`, `java/`, `qtcreator/`, `ideavim/` | App configs                           |
| `themes/`                  | Colorscheme experiments                                               |
| `packages/`                | Package lists (apt / pacman) for fresh installs                       |
| `install-iosevka-term.sh`  | Installs IosevkaTerm Nerd Font per-user (idempotent)                  |
| `copy.sh`                  | Live `$HOME` → repo (stage local changes)                             |
| `load.sh`                  | Repo → live `$HOME` (bootstrap a fresh machine)                       |
| `push.sh`                  | `copy.sh` + commit + push in one shot                                 |

## Usage

**Stage local changes and push them:**

```sh
./push.sh "feat: tweak kitty palette"
```

**Bootstrap a fresh machine:**

```sh
git clone git@github.com:arthurvalls/configs.git ~/configs
cd ~/configs
./load.sh
```

`load.sh` copies the repo into `$HOME`, installs IosevkaTerm Nerd Font, and refreshes `fc-cache`.

## Highlights

- **Theme**: [solarized-osaka](https://github.com/craftzdog/solarized-osaka.nvim) in nvim, mirrored to kitty via a custom palette file. On `:colorscheme <name>` inside nvim, a `ColorScheme` autocmd copies the matching kitty palette to `~/.config/kitty/current-theme.conf` and calls `kitty @ set-colors` to live-update the active window. Covers all nightfox variants and solarized-osaka — see `nvim/lua/config/plugins/nightfox.lua`.
- **Font**: IosevkaTerm Nerd Font Mono, installed by `install-iosevka-term.sh`.
- **Plugin manager**: [lazy.nvim](https://github.com/folke/lazy.nvim), with a single `lua/config/plugins.lua` aggregating per-plugin spec files.

## Also recommended on a fresh install

- [Starship](https://github.com/starship/starship) — prompt
- [eza](https://github.com/eza-community/eza) — better `ls`

### GNOME extensions

- Dash to Panel
- Resource Monitor
- Rounded Window Corners

## Requirements

- `git`, `curl`, `unzip`, `fc-cache` (fontconfig)
- For the nvim ↔ kitty theme sync: kitty needs `allow_remote_control yes` in `kitty.conf` (already set in this repo).
