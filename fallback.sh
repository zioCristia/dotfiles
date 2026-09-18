#!/usr/bin/env bash

# ==============================================================================
#  Dotfiles Fallback & Restore Script
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

# Check argument
if [ $# -lt 1 ]; then
    echo -e "${YELLOW}Usage:${NC} $0 <backup-directory>"
    echo -e "Example: $0 ~/.dotfiles_backup/20260918_120000"
    exit 1
fi

BACKUP_DIR_ARG="$1"

# Resolve path (cross-platform compatible method)
if [[ "${BACKUP_DIR_ARG}" == \~/* ]]; then
    # Manually expand tilde if it's there as a literal string
    BACKUP_DIR_ARG="${HOME}/${BACKUP_DIR_ARG#\~/}"
fi

# Get absolute path
if [ -d "${BACKUP_DIR_ARG}" ]; then
    BACKUP_DIR="$(cd "${BACKUP_DIR_ARG}" && pwd)"
else
    error "Backup directory '${BACKUP_DIR_ARG}' does not exist or is not a directory."
fi

# Print header
echo -e "${BLUE}"
echo "=========================================================="
echo "    ⏪  Restoring original dotfiles from backup  ⏪"
echo "=========================================================="
echo -e "${NC}"
info "Restoring from: ${CYAN}${BACKUP_DIR}${NC}"
info "Target home:     ${CYAN}${HOME}${NC}\n"

if ! confirm "Are you sure you want to restore the backup from this directory?" "N"; then
    info "Restore cancelled."
    exit 0
fi

# Change to backup directory to easily capture relative paths
cd "${BACKUP_DIR}"

# Find all files recursively in the backup directory
# (Including hidden files/directories, but ignoring '.' and '..')
# We use a temp file to store paths safely without issues on subshells/loops
temp_file_list="$(mktemp /tmp/fallback_files.XXXXXX)"
trap 'rm -f "${temp_file_list}"' EXIT

# Find all regular files in backup dir
find . -type f > "${temp_file_list}"

# Count files to restore
file_count=$(wc -l < "${temp_file_list}" | tr -d ' ')

if [ "${file_count}" -eq 0 ]; then
    warn "No files found to restore in the backup directory."
    exit 0
fi

info "Found ${file_count} file(s) to restore."

# Read files and restore them
while IFS= read -r file; do
    # Remove leading './'
    rel_path="${file#./}"
    dest_path="${HOME}/${rel_path}"

    info "Processing ${rel_path}..."

    # Handle existing target
    if [ -L "${dest_path}" ] || [ -e "${dest_path}" ]; then
        if [ -L "${dest_path}" ]; then
            info "  - Removing existing symlink: ${dest_path}"
            rm "${dest_path}"
        else
            if confirm "  - File ${dest_path} already exists. Overwrite with backup version?" "Y"; then
                rm -rf "${dest_path}"
            else
                info "  - Skipping ${dest_path}."
                continue
            fi
        fi
    fi

    # Ensure destination parent directory exists
    mkdir -p "$(dirname "${dest_path}")"

    # Copy file back from backup to $HOME
    cp "${file}" "${dest_path}"
    success "  - Restored: ${dest_path}"

done < "${temp_file_list}"

echo -e "\n${GREEN}=========================================================="
echo "          🎉  Restore Completed Successfully!  🎉"
echo "=========================================================="
echo -e "${NC}"
info "Your original files have been restored to ${HOME}."
info "Please restart your terminal session to apply any shell-profile changes."
