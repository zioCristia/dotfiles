#!/usr/bin/env bash

# ==============================================================================
#  Dotfiles Installation & Bootstrapping Script
# ==============================================================================
# Safe bash scripting settings
set -euo pipefail

# Text Formatting Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Setup directories
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${HOME}/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Print beautiful header
echo -e "${BLUE}"
echo "=========================================================="
echo "    💻  Populating & Bootstrapping Your Dotfiles  💻"
echo "=========================================================="
echo -e "${NC}"
echo -e "Dotfiles directory: ${CYAN}${DOTFILES_DIR}${NC}"
echo -e "Backup directory (if needed): ${CYAN}${BACKUP_DIR}${NC}\n"

# Helper: Print success message
success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Helper: Print info message
info() {
    echo -e "${BLUE}info:${NC} $1"
}

# Helper: Print warning message
warn() {
    echo -e "${YELLOW}warning:${NC} $1"
}

# Helper: Print error and exit
error() {
    echo -e "${RED}error:${NC} $1" >&2
    exit 1
}

# Check if command exists
cmd_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Ask for confirmation
confirm() {
    local prompt="$1"
    local default="${2:-Y}"
    local answer

    if [[ "${default}" == "Y" ]]; then
        prompt="${prompt} [Y/n]: "
    else
        prompt="${prompt} [y/N]: "
    fi

    read -rp "$(echo -e "${YELLOW}${prompt}${NC}")" answer
    answer="${answer:-${default}}"

    if [[ "${answer}" =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

# Create a symlink with backup handling
link_file() {
    local source_file="$1"
    local target_file="$2"

    # Ensure parent directory of target exists
    mkdir -p "$(dirname "${target_file}")"

    # Check if target already exists
    if [ -e "${target_file}" ] || [ -L "${target_file}" ]; then
        # If it is a symlink pointing to the right place, do nothing
        if [ -L "${target_file}" ] && [ "$(readlink "${target_file}")" == "${source_file}" ]; then
            info "Symlink for $(basename "${target_file}") already exists and is correct."
            return 0
        fi

        # Otherwise, backup existing file/link
        info "Backing up existing target ${target_file} to ${BACKUP_DIR}"
        mkdir -p "${BACKUP_DIR}/$(dirname "${target_file}" | sed "s|^${HOME}/||")"
        mv "${target_file}" "${BACKUP_DIR}/$(dirname "${target_file}" | sed "s|^${HOME}/||")/"
    fi

    # Create the symlink
    ln -s "${source_file}" "${target_file}"
    success "Linked ${target_file} -> ${source_file}"
}

# Check Operating System
OS="$(uname -s)"
if [[ "${OS}" != "Darwin" ]]; then
    warn "This script was primary designed for macOS (Darwin). Some features/tools may not work on ${OS}."
    if ! confirm "Do you want to proceed anyway?" "N"; then
        info "Exiting."
        exit 0
    fi
fi

# Check Prerequisites
echo -e "\n${PURPLE}--- Step 0: Checking Prerequisites ---${NC}"
for tool in git curl python3; do
    if ! cmd_exists "${tool}"; then
        error "Required prerequisite '${tool}' is not installed. Please install it before running this script."
    fi
done
success "All absolute prerequisites (git, curl, python3) are met."

# ==============================================================================
#  Phase 1: Tool Installation (Interactive)
# ==============================================================================
echo -e "\n${PURPLE}--- Step 1: Checking & Installing Dependencies ---${NC}"

# macOS Brew & Casks
if [[ "${OS}" == "Darwin" ]]; then
    # Homebrew
    if ! cmd_exists brew; then
        if confirm "Homebrew is not installed. Would you like to install it?" "Y"; then
            info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            # Add brew to path for the rest of this script execution
            if [[ -f "/opt/homebrew/bin/brew" ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            elif [[ -f "/usr/local/bin/brew" ]]; then
                eval "$(/usr/local/bin/brew shellenv)"
            fi
        else
            warn "Skipping Homebrew installation. Other tools might fail to install."
        fi
    else
        success "Homebrew is installed."
    fi

    # Homebrew Packages (Only if Brew is available)
    if cmd_exists brew; then
        # CLI Tools list
        declare -A brew_pkgs=(
            ["kubectx"]="kubectx (and kubens)"
            ["zoxide"]="zoxide (smarter cd command)"
            ["kube-ps1"]="kube-ps1 (K8s context/namespace prompt)"
            ["k9s"]="k9s (Kubernetes CLI UI)"
            ["n2s"]="n2s (NATS CLI UI)"
        )

        for pkg in "${!brew_pkgs[@]}"; do
            if ! cmd_exists "${pkg}" && [ "${pkg}" != "kube-ps1" ]; then # kube-ps1 doesn't have a binary, checked differently
                if confirm "Install ${brew_pkgs[${pkg}]} via brew?" "Y"; then
                    info "Installing ${pkg}..."
                    brew install "${pkg}"
                fi
            elif [ "${pkg}" == "kube-ps1" ] && [ ! -f "/opt/homebrew/opt/kube-ps1/share/kube-ps1.sh" ] && [ ! -f "/usr/local/opt/kube-ps1/share/kube-ps1.sh" ]; then
                if confirm "Install kube-ps1 via brew?" "Y"; then
                    info "Installing kube-ps1..."
                    brew install kube-ps1
                fi
            else
                success "${brew_pkgs[${pkg}]} is already installed."
            fi
        done

        # GUI Casks list
        declare -A brew_casks=(
            ["karabiner-elements"]="Karabiner-Elements (keyboard customizer)"
            ["hammerspoon"]="Hammerspoon (desktop automation)"
        )

        for cask in "${!brew_casks[@]}"; do
            # App paths checking on macOS
            local app_name=""
            if [[ "${cask}" == "karabiner-elements" ]]; then app_name="Karabiner-Elements.app"; fi
            if [[ "${cask}" == "hammerspoon" ]]; then app_name="Hammerspoon.app"; fi

            if [ -n "${app_name}" ] && [ ! -d "/Applications/${app_name}" ] && [ ! -d "${HOME}/Applications/${app_name}" ]; then
                if confirm "Install ${brew_casks[${cask}]} via brew cask?" "Y"; then
                    info "Installing ${cask}..."
                    brew install --cask "${cask}"
                fi
            else
                success "${brew_casks[${cask}]} is already installed."
            fi
        done
    fi
fi

# Oh My Zsh (Multiplatform)
if [ ! -d "${HOME}/.oh-my-zsh" ]; then
    if confirm "Oh My Zsh is not installed. Would you like to install it?" "Y"; then
        info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        success "Oh My Zsh installed."
    else
        warn "Skipping Oh My Zsh installation. Your .zshrc expects it to exist."
    fi
else
    success "Oh My Zsh is installed."
fi


# ==============================================================================
#  Phase 2: Linking Dotfiles
# ==============================================================================
echo -e "\n${PURPLE}--- Step 2: Symlinking Configuration Files ---${NC}"

# Shells
link_file "${DOTFILES_DIR}/zsh/.zshrc" "${HOME}/.zshrc"
link_file "${DOTFILES_DIR}/zsh/.zprofile" "${HOME}/.zprofile"
link_file "${DOTFILES_DIR}/bash/.bashrc" "${HOME}/.bashrc"
link_file "${DOTFILES_DIR}/bash/.bash_profile" "${HOME}/.bash_profile"

# Karabiner (macOS only or if config dir exists)
if [[ "${OS}" == "Darwin" ]]; then
    info "Compiling modular Karabiner-Elements profile..."
    python3 "${DOTFILES_DIR}/karabiner/compile.py"
    link_file "${DOTFILES_DIR}/karabiner/karabiner.json" "${HOME}/.config/karabiner/karabiner.json"
fi

# Hammerspoon (macOS only)
if [[ "${OS}" == "Darwin" ]]; then
    link_file "${DOTFILES_DIR}/hammerspoon/init.lua" "${HOME}/.hammerspoon/init.lua"
fi

# Vim & Dracula Theme
link_file "${DOTFILES_DIR}/vim/.vimrc" "${HOME}/.vimrc"
if [ ! -d "${HOME}/.vim/pack/themes/start/dracula" ]; then
    if confirm "Vim Dracula theme not found. Clone it from GitHub?" "Y"; then
        info "Cloning Vim Dracula theme..."
        mkdir -p "${HOME}/.vim/pack/themes/start"
        git clone https://github.com/dracula/vim.git "${HOME}/.vim/pack/themes/start/dracula"
        success "Cloned Dracula theme to ~/.vim/pack/themes/start/dracula"
    fi
fi

# ==============================================================================
#  Completion
# ==============================================================================
echo -e "\n${GREEN}=========================================================="
echo "          🎉  Dotfiles Setup Completed!  🎉"
echo "=========================================================="
echo -e "${NC}"
info "If any original files were overwritten, they have been backed up in:"
echo -e "   ${CYAN}${BACKUP_DIR}${NC}\n"

info "To load the new configuration in your current terminal session, run:"
echo -e "   ${GREEN}source ~/.zshrc${NC}  (or open a new terminal window)\n"

warn "For Karabiner and Hammerspoon changes to take effect:"
echo "1. Ensure both Karabiner-Elements and Hammerspoon are running."
echo "2. Grant necessary Accessibility permissions in macOS Settings if prompted."
