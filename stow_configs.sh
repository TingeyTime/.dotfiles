#!/usr/bin/env bash
#
# stow_configs.sh - Interactive dotfiles manager using fzf
#
# DESCRIPTION:
#   An interactive TUI for managing dotfile configurations using GNU Stow.
#   Uses fzf for package selection.
#
# REQUIREMENTS:
#   - fzf (install via: brew install fzf, apt install fzf, etc.)
#   - GNU Stow
#   - Each tool directory must contain either install.sh or be stowable

set -euo pipefail

# Check for fzf
if ! command -v fzf &>/dev/null; then
    echo "fzf is required. Install via your package manager:"
    echo "  brew install fzf      # macOS"
    echo "  apt install fzf        # Debian/Ubuntu"
    echo "  dnf install fzf        # Fedora"
    echo "  pacman -S fzf          # Arch"
    exit 1
fi

# Package definitions: maps directory name to target symlink location
declare -A PKG_TARGETS=(
    [nvim]="$HOME/.config/nvim"
    [git]="$HOME/.config"
    [starship]="$HOME/.config"
    [tmux]="$HOME"
    [zshrc]="$HOME"
)

# Human-readable descriptions for each package
declare -A PKG_DESCRIPTIONS=(
    [nvim]="Neovim editor"
    [git]="Git configuration"
    [starship]="Starship prompt"
    [tmux]="Terminal multiplexer"
    [zshrc]="Zsh configuration"
)

#-----------------------------------------------------------------------
# Detects whether a tool is installed on the system
#-----------------------------------------------------------------------
detect_installed() {
    local pkg="$1"
    case "$pkg" in
        zshrc) command -v zsh &>/dev/null ;;
        git)   command -v git &>/dev/null ;;
        nvim)  command -v nvim &>/dev/null || command -v vim &>/dev/null ;;
        *)     command -v "$pkg" &>/dev/null ;;
    esac
}

#-----------------------------------------------------------------------
# Initialize available packages and their installation status
#-----------------------------------------------------------------------
available=()
declare -A pkg_status

for pkg in "${!PKG_TARGETS[@]}"; do
    if [[ -d "$pkg" ]]; then
        available+=("$pkg")
        if detect_installed "$pkg"; then
            pkg_status[$pkg]="installed"
        else
            pkg_status[$pkg]="not installed"
        fi
    fi
done

if [[ ${#available[@]} -eq 0 ]]; then
    echo "No packages found to stow."
    exit 0
fi

#-----------------------------------------------------------------------
# Build choices for fzf - only show packages that are installed (selectable)
#-----------------------------------------------------------------------
installed_pkgs=()
choices=()
for pkg in "${available[@]}"; do
    if [[ "${pkg_status[$pkg]}" == "installed" ]]; then
        installed_pkgs+=("$pkg")
        choices+=("$pkg - ${PKG_DESCRIPTIONS[$pkg]} (installed)")
    fi
done

if [[ ${#choices[@]} -eq 0 ]]; then
    echo "No installed packages found to manage."
    exit 0
fi

#-----------------------------------------------------------------------
# Run fzf for package selection
#-----------------------------------------------------------------------
echo "Select packages to stow (Space to toggle, Enter to confirm):"
echo

selected_output=$(printf '%s\n' "${choices[@]}" | fzf \
    --multi \
    --prompt="Select> " \
    --header="Toggle with Tab, confirm with Enter" \
    --height=50% \
    --reverse)

# Parse selected packages from fzf output
selected=()
while IFS= read -r line; do
    pkg="${line%% - *}"
    selected+=("$pkg")
done <<< "$selected_output"

# Exit if nothing selected
if [[ ${#selected[@]} -eq 0 ]]; then
    echo "No packages selected. Exiting."
    exit 0
fi

#-----------------------------------------------------------------------
# Determine which packages need to be uninstalled
#-----------------------------------------------------------------------
previously_selected=("${installed_pkgs[@]}")

echo
echo "Selected: ${selected[*]}"
echo

# Uninstall deselected packages
for pkg in "${previously_selected[@]}"; do
    if [[ ! " ${selected[*]} " =~ " ${pkg} " ]]; then
        target="${PKG_TARGETS[$pkg]}"
        echo "==> Uninstalling $pkg (was previously stowed)"

        if [[ -f "$pkg/uninstall.sh" ]]; then
            bash "$pkg/uninstall.sh" "$target"
        else
            echo "    No uninstall.sh found, using unstow"
            stow --unstealth -t "$target" -d . "$pkg" 2>/dev/null || \
                stow --delete -t "$target" -d . "$pkg" 2>/dev/null || \
                echo "    Warning: could not unstow $pkg"
        fi
    fi
done

# Install/refresh selected packages
for pkg in "${selected[@]}"; do
    target="${PKG_TARGETS[$pkg]}"
    echo "==> Stowing $pkg -> $target"

    if [[ -f "$pkg/install.sh" ]]; then
        bash "$pkg/install.sh" "$target"
    else
        mkdir -p "$target"
        stow --restow --no-folding --ignore='^install\.sh$' --ignore='^uninstall\.sh$' -t "$target" "$pkg"
    fi
done

echo
echo "Done!"
