#!/bin/zsh
# setup.sh - dotfiles bootstrap script (macOS / Apple Silicon)
#
# Usage:
#   ./setup.sh                  # Run all steps
#   ./setup.sh --skip-casks     # Skip GUI apps and fonts (e.g. headless environments)

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
SKIP_CASKS=false

for arg in "$@"; do
  case $arg in
    --skip-casks) SKIP_CASKS=true ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done

# ---------- Output helpers ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

step()    { echo "\n${BLUE}==>${RESET} ${BOLD}$*${RESET}" }
success() { echo "${GREEN}  ✓${RESET} $*" }
warn()    { echo "${YELLOW}  !${RESET} $*" }
abort()   { echo "${RED}  ✗${RESET} $*" >&2; exit 1 }

# ---------- 1. Homebrew ----------
step "Homebrew"
if command -v brew &>/dev/null; then
  success "Already installed (skipping)"
else
  warn "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Apply shellenv immediately for Apple Silicon
  eval "$(/opt/homebrew/bin/brew shellenv)"
  success "Installed"
fi

# Re-evaluate in case shellenv was not yet active
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# ---------- 2. CLI tools ----------
step "CLI tools (brew install)"

FORMULAE=(
  stow
  neovim
  tmux
  lazygit
  yazi
  starship
  fzf
  zoxide
  eza
  bat
  fastfetch
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
)

MISSING=()
for pkg in "${FORMULAE[@]}"; do
  brew list --formula "$pkg" &>/dev/null || MISSING+=("$pkg")
done

if [[ ${#MISSING[@]} -eq 0 ]]; then
  success "All formulae already installed (skipping)"
else
  warn "Missing: ${MISSING[*]}"
  brew install "${MISSING[@]}"
  success "Installed"
fi

# ---------- 3. GUI apps and fonts ----------
if [[ "$SKIP_CASKS" == true ]]; then
  warn "--skip-casks specified: skipping GUI apps and fonts"
else
  step "Terminal emulators (brew install --cask)"

  CASKS=(wezterm ghostty)
  MISSING_CASKS=()
  for cask in "${CASKS[@]}"; do
    brew list --cask "$cask" &>/dev/null || MISSING_CASKS+=("$cask")
  done

  if [[ ${#MISSING_CASKS[@]} -eq 0 ]]; then
    success "Already installed (skipping)"
  else
    brew install --cask "${MISSING_CASKS[@]}"
    success "Installed"
  fi

  step "Fonts"

  # Firge Nerd Console (for WezTerm)
  if brew list --cask font-firge &>/dev/null; then
    success "font-firge: already installed (skipping)"
  else
    brew install --cask font-firge
    success "font-firge: installed"
  fi

  # MoralerspaceNeonHWNF (for Ghostty)
  # The brew cask is discontinued upstream, so fetch from GitHub Releases directly
  MORALERSPACE_CHECK=$(find "$HOME/Library/Fonts" /Library/Fonts \
    -name "*MoralerspaceNeonHW*NF*" 2>/dev/null | head -1)

  if [[ -n "$MORALERSPACE_CHECK" ]]; then
    success "MoralerspaceNeonHWNF: already installed (skipping)"
  else
    warn "Downloading MoralerspaceNeonHWNF from GitHub Releases..."
    RELEASE_URL=$(curl -fsSL \
      "https://api.github.com/repos/yuru7/moralerspace/releases/latest" \
      | grep "browser_download_url" \
      | grep "MoralerspaceNeonHW_NF" \
      | grep "\.zip" \
      | head -1 \
      | cut -d '"' -f 4)

    if [[ -z "$RELEASE_URL" ]]; then
      warn "Could not resolve download URL. Install manually:"
      warn "  https://github.com/yuru7/moralerspace/releases"
    else
      TMP_DIR=$(mktemp -d)
      curl -fsSL "$RELEASE_URL" -o "$TMP_DIR/moralerspace.zip"
      unzip -q "$TMP_DIR/moralerspace.zip" -d "$TMP_DIR"
      find "$TMP_DIR" -name "*.ttf" -exec cp {} "$HOME/Library/Fonts/" \;
      rm -rf "$TMP_DIR"
      success "MoralerspaceNeonHWNF: installed"
    fi
  fi
fi

# ---------- 4. Apply dotfiles ----------
step "Dotfiles (stow)"

STOW_PACKAGES=(ghostty lazygit nvim starship tmux wezterm yazi zsh)

cd "$DOTFILES_DIR"
stow --target="$HOME" "${STOW_PACKAGES[@]}"
success "Symlinks created"

# ---------- 5. TPM (tmux Plugin Manager) ----------
step "TPM (tmux Plugin Manager)"

TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ -d "$TPM_DIR" ]]; then
  success "Already installed (skipping)"
else
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
  success "Installed"
fi

warn "Open tmux and press prefix + I to install plugins"

# ---------- 6. Neovim plugins ----------
step "Neovim plugins (lazy.nvim)"

nvim --headless "+Lazy! sync" +qa 2>&1 | grep -v "^$" || true
success "Plugins synced"
warn "LSP servers will be installed automatically by Mason on first nvim launch"

# ---------- Done ----------
echo "\n${GREEN}${BOLD}Setup complete!${RESET}"
echo "Open a new shell or run: source ~/.zshrc"
