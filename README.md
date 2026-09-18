# My Dotfiles

A clean, modular repository for saving and restoring developer configurations across machines (specifically macOS). It stores setup profiles for **Zsh**, **Bash**, **Karabiner-Elements**, **Hammerspoon**, and **Vim**.

---

## 📦 What's Included

*   **Zsh Configuration**: Custom `.zshrc` and `.zprofile` featuring:
    *   Oh My Zsh integration (themes & plugins)
    *   Smarter navigation via `zoxide`
    *   Kubernetes integration (`kubectx`/`kubens`, `kube-ps1` prompt, and `k9s` CLI UI dashboard)
    *   Rich custom aliases for Maven/Java development, Git workflows, and AI agent init.
*   **Bash Configuration**: Clean `.bashrc` and `.bash_profile` supporting SDKMAN and Rancher Desktop.
*   **Karabiner-Elements**: Deep, modularized keyboard modifications (e.g., option-based vim arrows `Option + H/J/K/L`, capslock tweaks, hold modifications, and mapping tilde to `F18` for Hammerspoon's hyper-key).
*   **Hammerspoon**: A modal orchestration layout (using `F18` as a trigger for application launching and space switching).
*   **Vim Configuration**: Custom `.vimrc` integrated with the Dracula Vim colorscheme (automatically cloned during setup).

---

## 📋 Prerequisites

To run the automated bootstrap script or compile modular settings, your system must have these basic tools pre-installed:

1.  **Git**: Used to clone and manage this repository.
2.  **Curl**: Used to download dependencies (such as Homebrew and Oh My Zsh).
3.  **Python 3**: Used by the Karabiner compiler script (`compile.py`).

*Note: On macOS, running `git` or `python3` in a fresh terminal for the first time will automatically prompt you to install the **Xcode Command Line Tools** which includes all three prerequisites.*

---

## 🎹 Modular Karabiner-Elements Setup

Instead of maintaining a massive single `karabiner.json` file (which easily gets convoluted), this repository splits your rules into logical, individual modules under `karabiner/rules/`:

*   `01_caps_lock.json`: Maps CapsLock to Control (held) / Escape (tapped).
*   `02_slash_shift.json`: Maps Slash to Right Shift (held) / Slash (tapped).
*   `03_shift_backspace.json`: Maps Shift-Backspace to Forward Delete.
*   `04_option_arrows.json`: Maps Option + `h`/`j`/`k`/`l` to directional arrows.
*   `05_right_command_return.json`: Deep Right-Command held/tap modifications for Return mapping.
*   `06_left_command_backspace.json`: Maps Left-Command to Backspace on tap, Command on hold.
*   `07_grave_accent_tilde_f18.json`: Maps Backtick/Tilde to `F18` (held) and Escape (tapped), acting as the Hammerspoon Hyper key trigger.

### Compiling Rules
Any time you modify a file in `karabiner/rules/` or add a new one, compile the main configuration by running:

```bash
python3 karabiner/compile.py
```

The script automatically gathers all rules in alphabetical order, embeds them into a clean Karabiner profile template, and generates the final, fully populated `karabiner/karabiner.json`.

---

## 🚀 Automated Installation (Recommended)

To bootstrap your setup on a new machine, clone this repository and run the interactive installation script.

```bash
cd ~/workspace/dotfiles
chmod +x install.sh
./install.sh
```

### What `install.sh` does:
1.  **Verifies Prerequisites**: Validates that `git`, `curl`, and `python3` are available before proceeding.
2.  **Backs Up Existing Configs**: Any existing configurations (e.g., `~/.zshrc`, `~/.vimrc`) are backed up inside a timestamped folder under `~/.dotfiles_backup/` so you never lose anything.
3.  **Installs Missing Packages**: Interactively prompts to install Homebrew, Oh My Zsh, `kubectx`/`kubens`, `zoxide`, `kube-ps1`, `k9s`, Karabiner-Elements, and Hammerspoon if they aren't already installed.
4.  **Compiles Karabiner Configuration**: Runs the Python compilation script to build your latest `karabiner.json` automatically from your modular rules folder.
5.  **Symlinks Dotfiles**: Creates symbolic links from your home directories directly to this repository, ensuring changes made in either location are in sync.
6.  **Vim Dracula Bootstrap**: Automatically clones the Dracula colorscheme repository directly into Vim's native package start folder (`~/.vim/pack/themes/start/dracula`).

### ⏪ Reverting / Restoring Backup Configurations

If you ever need to revert the symlinks and restore your original configuration files from a backup created by `install.sh`, you can run the `fallback.sh` script with the backup folder path as an argument:

```bash
cd ~/workspace/dotfiles
chmod +x fallback.sh
./fallback.sh ~/.dotfiles_backup/YYYYMMDD_HHMMSS
```

This will automatically:
1. Detect and safely remove any existing dotfile symlinks.
2. Interactively prompt before overwriting any modified local configuration files.
3. Copy all original configurations back to their exact original paths under your home directory.

---

## 🛠️ Manual Installation (Without Script)

If you prefer to link your configurations manually without using the script, follow these steps:

### 1. Install Dependencies

Install the core utilities using Homebrew:

```bash
# Install Homebrew (if not present)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install CLI dependencies (including k9s and n2s)
brew install kubectx zoxide kube-ps1 k9s n2s

# Install GUI tools (macOS only)
brew install --cask karabiner-elements hammerspoon

# Install Oh My Zsh
sh -c "$(curl -fsSL toughness/ohmyzsh/master/tools/install.sh)"
```

### 2. Manual Compile, Backup & Symlink

Run these commands to compile your rules, backup your current configurations, and manually link the repository files.

#### Shell Profiles
```bash
# Backup existing configurations
mkdir -p ~/.dotfiles_backup/manual
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.dotfiles_backup/manual/
[ -f ~/.zprofile ] && mv ~/.zprofile ~/.dotfiles_backup/manual/
[ -f ~/.bashrc ] && mv ~/.bashrc ~/.dotfiles_backup/manual/
[ -f ~/.bash_profile ] && mv ~/.bash_profile ~/.dotfiles_backup/manual/

# Create symlinks
ln -s ~/workspace/dotfiles/zsh/.zshrc ~/.zshrc
ln -s ~/workspace/dotfiles/zsh/.zprofile ~/.zprofile
ln -s ~/workspace/dotfiles/bash/.bashrc ~/.bashrc
ln -s ~/workspace/dotfiles/bash/.bash_profile ~/.bash_profile
```

#### Karabiner Elements (Keyboard modifications)
```bash
# Compile the modular rules into the single config file first
python3 ~/workspace/dotfiles/karabiner/compile.py

# Ensure the configuration directory exists
mkdir -p ~/.config/karabiner

# Backup existing config if it exists
[ -f ~/.config/karabiner/karabiner.json ] && mv ~/.config/karabiner/karabiner.json ~/.dotfiles_backup/manual/

# Create symlink
ln -s ~/workspace/dotfiles/karabiner/karabiner.json ~/.config/karabiner/karabiner.json
```

#### Hammerspoon (Desktop shortcuts)
```bash
# Ensure the configuration directory exists
mkdir -p ~/.hammerspoon

# Backup existing config if it exists
[ -f ~/.hammerspoon/init.lua ] && mv ~/.hammerspoon/init.lua ~/.dotfiles_backup/manual/

# Create symlink
ln -s ~/workspace/dotfiles/hammerspoon/init.lua ~/.hammerspoon/init.lua
```

#### Vim & Dracula Theme setup
```bash
# Ensure the vim configurations are backed up
[ -f ~/.vimrc ] && mv ~/.vimrc ~/.dotfiles_backup/manual/

# Create symlink
ln -s ~/workspace/dotfiles/vim/.vimrc ~/.vimrc

# Clone Dracula colorscheme into pack directory
mkdir -p ~/.vim/pack/themes/start
git clone https://github.com/dracula/vim.git ~/.vim/pack/themes/start/dracula
```

### 3. Apply Configs

To load the shell configurations immediately:
```bash
source ~/.zshrc
```

Make sure Karabiner-Elements and Hammerspoon are launched, and enable Accessibility permissions under **System Settings > Privacy & Security > Accessibility** for them to operate.

---

## ➕ How to Add New Tools & Keymaps

To expand your environment, customize configurations, or track new tools, follow these patterns:

### 1. Adding a New Command-Line Tool (e.g., `kubefs`)
*   **Step A: Configure:** Add the tool's environment paths, shell source scripts, or custom aliases to your active terminal. Since `~/.zshrc` is a symlink pointing to your repository's `zsh/.zshrc`, editing `~/.zshrc` automatically keeps the repository updated.
*   **Step B: Automate Installation:** Open `install.sh` and add your new tool and description to the `brew_pkgs` and `brew_pkgs_desc` arrays, so it gets auto-installed on a new machine:
    ```bash
    brew_pkgs=(
        ...
        "kubefs"
    )
    brew_pkgs_desc=(
        ...
        "kubefs (K8s virtual file system mount tool)"
    )
    ```
*   **Step C: Commit:** Commit and push the changes:
    ```bash
    git commit -am "feat: add kubefs configuration & installer"
    ```

### 2. Adding a New Keyboard Rule (Karabiner Elements)
*   **Step A: Create Rule:** Create a new JSON file under `karabiner/rules/` with a sequential prefix to determine its loading order (e.g., `karabiner/rules/08_my_custom_keymap.json`).
*   **Step B: Compile:** Recompile your profile:
    ```bash
    python3 karabiner/compile.py
    ```
*   **Step C: Commit:** Save your changes:
    ```bash
    git add karabiner/rules/08_my_custom_keymap.json
    git commit -am "feat: add custom Karabiner mapping for new workspace"
    ```
