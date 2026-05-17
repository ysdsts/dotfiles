# dotfiles

macOS dotfiles managed with GNU Stow.

## Packages

| Package    | Target |
|------------|--------|
| `ghostty`  | `~/.config/ghostty/` |
| `lazygit`  | `~/.config/lazygit/` |
| `nvim`     | `~/.config/nvim/` |
| `starship` | `~/.config/starship.toml` |
| `tmux`     | `~/.config/tmux/tmux.conf` |
| `wezterm`  | `~/.config/wezterm/` |
| `yazi`     | `~/.config/yazi/` |
| `zsh`      | `~/.zshrc` |

## Setup

### One-shot script

```bash
git clone <repo-url> ~/dotfiles
~/dotfiles/setup.sh
```

Skip GUI apps and fonts (e.g. headless environments):

```bash
~/dotfiles/setup.sh --skip-casks
```

---

To run each step manually, follow the sections below.

### 1. Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After installation, activate the shell environment added to `~/.zprofile` before proceeding:

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### 2. CLI tools

```bash
brew install stow neovim tmux lazygit yazi starship \
             fzf zoxide eza bat fastfetch \
             zsh-autosuggestions zsh-syntax-highlighting zsh-completions
```

### 3. Terminal emulators

Install whichever you use:

```bash
brew install --cask wezterm
brew install --cask ghostty
```

### 4. Fonts

**WezTerm** (font: Firge35Nerd Console)

```bash
brew install --cask font-firge
```

**Ghostty** (font: MoralerspaceNeonHWNF)

The brew cask is discontinued upstream. Download the latest `MoralerspaceNeonHW_NF_*.zip` from the [Moralerspace releases page](https://github.com/yuru7/moralerspace/releases) and install the font files manually.

### 5. Apply dotfiles

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles

# Apply all packages at once
stow --target="$HOME" ghostty lazygit nvim starship tmux wezterm yazi zsh

# Or apply individual packages
stow --target="$HOME" nvim
```

### 6. tmux plugins (TPM)

```bash
git clone --depth=1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Start tmux and press `prefix + I` to install plugins.

### 7. Neovim plugins

```bash
nvim
```

lazy.nvim installs plugins automatically on first launch. LSP servers are managed by Mason — run `:Mason` to check the status.

## Notes

- `~/.config/tmux/plugins/` is managed by TPM and is not tracked in this repo
- `yazi/bookmarks.tsv` changes at runtime and is excluded via `.gitignore`
