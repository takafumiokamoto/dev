#!/bin/bash
#
# install-deps.sh
#
# This script installs the required dependencies for your Neovim configuration on Linux.
# It automatically detects the package manager and installs the necessary tools.
#
# To run this script:
# 1. Save it as `install-deps.sh`.
# 2. Open your terminal.
# 3. Make the script executable: `chmod +x install-deps.sh`
# 4. Run the script with sudo: `./install-deps.sh`

# --- Helper Functions ---
print_info() {
    # Blue color
    printf "\n\e[34m%s\e[0m\n" "$1"
}

print_success() {
    # Green color
    printf "\e[32m%s\e[0m\n" "$1"
}

print_error() {
    # Red color
    printf "\e[31m%s\e[0m\n" "$1" >&2
}

# --- Main Script ---
print_info "Starting dependency installation for Neovim..."

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  print_error "This script needs to be run with sudo or as root."
  print_error "Please run it like this: sudo ./install-deps.sh"
  exit 1
fi

# Detect the package manager and install dependencies
if command -v apt-get &> /dev/null; then
    print_info "Detected Debian/Ubuntu based system. Using apt-get."
    apt-get update
    apt-get install -y git build-essential cmake ripgrep

elif command -v pacman &> /dev/null; then
    print_info "Detected Arch Linux based system. Using pacman."
    pacman -Syu --noconfirm git base-devel cmake ripgrep

elif command -v dnf &> /dev/null; then
    print_info "Detected Fedora/RHEL based system. Using dnf."
    dnf groupinstall -y "Development Tools"
    dnf install -y git cmake ripgrep

elif command -v zypper &> /dev/null; then
    print_info "Detected openSUSE based system. Using zypper."
    zypper install -y git-core patterns-devel-base-devel_basis cmake ripgrep

else
    print_error "Could not detect a supported package manager (apt, pacman, dnf, zypper)."
    print_error "Please install the following packages manually:"
    print_error " - git"
    print_error " - cmake"
    print_error " - ripgrep"
    print_error " - A C/C++ compiler toolchain (like build-essential, base-devel, etc.)"
    exit 1
fi

# Check if the last command was successful
if [ $? -eq 0 ]; then
    echo ""
    print_success "------------------------------------------------------------------"
    print_success "✅ All required tools have been installed successfully."
    echo ""
    print_info "Next Steps:"
    echo "1. Install a Nerd Font for icons to display correctly."
    echo "   - Go to: https://www.nerdfonts.com/font-downloads"
    echo "   - Download a font (e.g., FiraCode, JetBrainsMono, CaskaydiaCove)."
    echo "   - Follow your distribution's instructions for installing fonts (usually involves copying to ~/.local/share/fonts and running fc-cache -fv)."
    echo "2. Configure your terminal emulator to use the new font."
    echo "3. Restart your terminal and Neovim for all changes to take effect."
    print_success "------------------------------------------------------------------"
else
    print_error "An error occurred during package installation. Please check the output above."
    exit 1
fi

# --- Create Symbolic Link ---
print_info "------------------------------------------------------------------"
print_info "Attempting to create a symbolic link for the Neovim configuration."
print_info "This will link this directory to ~/.config/nvim"
print_info "------------------------------------------------------------------"

# Source is the directory where this script is located.
SOURCE_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
TARGET_PATH="${HOME}/.config/nvim"

echo "Source: $SOURCE_PATH"
echo "Target: $TARGET_PATH"

# Ensure the parent directory of the target exists
mkdir -p "$(dirname "$TARGET_PATH")"

# Check if the target path exists
if [ -e "$TARGET_PATH" ]; then
    # Check if it's already a symbolic link pointing to the correct source
    if [ -L "$TARGET_PATH" ] && [ "$(readlink "$TARGET_PATH")" = "$SOURCE_PATH" ]; then
        print_success "Symbolic link already exists and points to the correct location. No action needed."
    else
        # It's a file or a directory, or a wrong symlink, so back it up
        BACKUP_PATH="${TARGET_PATH}.bak"
        print_info "Existing configuration found at target. Backing it up to '$BACKUP_PATH'..."
        if [ -e "$BACKUP_PATH" ]; then
            rm -rf "$BACKUP_PATH"
            echo "Removed existing backup at '$BACKUP_PATH'."
        fi
        mv "$TARGET_PATH" "$BACKUP_PATH"
        print_success "Backup complete. Creating new symbolic link."
        ln -s "$SOURCE_PATH" "$TARGET_PATH"
        print_success "Successfully created symbolic link."
    fi
else
    # Target doesn't exist, so just create the link
    print_info "No existing configuration found at target. Creating symbolic link."
    ln -s "$SOURCE_PATH" "$TARGET_PATH"
    print_success "Successfully created symbolic link."
fi