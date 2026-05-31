#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PACKAGES_FILE="$SCRIPT_DIR/packages.txt"
DOTFILES_DIR="$SCRIPT_DIR/dotfiles"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Starting Arch Linux System Setup ===${NC}"

# Check if script is running on Arch Linux
if [ ! -f /etc/arch-release ]; then
    echo -e "${RED}Error: This script is intended for Arch Linux only.${NC}"
    exit 1
fi

# Function to safely create symlinks
symlink_file() {
    local src="$1"
    local dest="$2"

    # Create destination directory if it doesn't exist
    mkdir -p "$(dirname "$dest")"

    # Backup existing file if it exists and is not a symlink
    if [ -e "$dest" ] || [ -h "$dest" ]; then
        if [ ! -L "$dest" ]; then
            echo -e "${YELLOW}Backing up existing file: $dest -> ${dest}.backup${NC}"
            mv "$dest" "${dest}.backup"
        else
            # If it's already a symlink, remove it to update it
            rm "$dest"
        fi
    fi

    echo -e "Symlinking: ${GREEN}$dest${NC} -> $src"
    ln -s "$src" "$dest"
}

# Step 1: Install packages
if [ -f "$PACKAGES_FILE" ]; then
    echo -e "\n${BLUE}[1/3] Installing packages from packages.txt...${NC}"
    # Read packages from file, filtering out empty lines and comments
    packages=()
    while IFS= read -r line; do
        # Ignore empty lines and comments
        [[ -z "$line" || "$line" =~ ^# ]] && continue
        packages+=("$line")
    done < "$PACKAGES_FILE"

    if [ ${#packages[@]} -gt 0 ]; then
        echo -e "Installing: ${packages[*]}"
        sudo pacman -S --needed --noconfirm "${packages[@]}"
    else
        echo -e "${YELLOW}No packages found to install.${NC}"
    fi
else
    echo -e "${RED}Warning: packages.txt not found! Skipping package installation.${NC}"
fi

# Step 2: Install AUR packages
if [ -f "$SCRIPT_DIR/aur_packages.txt" ]; then
    echo -e "\n${BLUE}[2/3] Installing AUR packages from aur_packages.txt...${NC}"

    # Check if yay is installed, if not install it
    if ! command -v yay &> /dev/null; then
        echo -e "${YELLOW}yay is not installed. Installing yay-bin from AUR...${NC}"
        temp_dir=$(mktemp -d)
        git clone https://aur.archlinux.org/yay-bin.git "$temp_dir"
        (cd "$temp_dir" && makepkg -si --noconfirm)
        rm -rf "$temp_dir"
    fi

    # Read AUR packages from file
    aur_packages=()
    while IFS= read -r line; do
        [[ -z "$line" || "$line" =~ ^# ]] && continue
        # yay-bin is already installed, skip it
        [[ "$line" == "yay-bin" ]] && continue
        aur_packages+=("$line")
    done < "$SCRIPT_DIR/aur_packages.txt"

    if [ ${#aur_packages[@]} -gt 0 ]; then
        echo -e "Installing AUR packages: ${aur_packages[*]}"
        yay -S --needed --noconfirm "${aur_packages[@]}"
    else
        echo -e "${YELLOW}No extra AUR packages to install.${NC}"
    fi
else
    echo -e "${RED}Warning: aur_packages.txt not found! Skipping AUR installation.${NC}"
fi

# Step 3: Apply dotfiles
echo -e "\n${BLUE}[3/3] Applying dotfiles (creating symlinks)...${NC}"

# Symlink individual configuration files
symlink_file "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
symlink_file "$DOTFILES_DIR/.bash_profile" "$HOME/.bash_profile"
symlink_file "$DOTFILES_DIR/.config/dolphinrc" "$HOME/.config/dolphinrc"
symlink_file "$DOTFILES_DIR/.config/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
symlink_file "$DOTFILES_DIR/.config/hypr/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"
symlink_file "$DOTFILES_DIR/.config/hypr/shortcuts.py" "$HOME/.config/hypr/shortcuts.py"
symlink_file "$DOTFILES_DIR/.vscode-oss/argv.json" "$HOME/.vscode-oss/argv.json"

echo -e "\n${GREEN}=== Setup completed successfully! ===${NC}"
echo -e "${YELLOW}Note: You may need to log out and log back in (or run 'hyprctl dispatch exit') to apply all changes.${NC}"
