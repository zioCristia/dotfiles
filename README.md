# My Dotfiles

A clean, modular repository for saving and restoring developer configurations across machines (specifically macOS). It stores setup profiles for **Zsh**, **Bash**, **Karabiner-Elements**, **Hammerspoon**, and **Vim**.

---

## 📦 What's Included

*   **Zsh Configuration**: Custom `.zshrc` and `.zprofile` featuring:
    *   Oh My Zsh integration (themes & plugins, including `zsh-sage` intelligent autosuggestions)
    *   Smarter navigation via `zoxide`
    *   Kubernetes integration (`kubectx`/`kubens`, `kube-ps1` prompt, and `k9s` CLI UI dashboard)
    *   Rich custom aliases for Maven/Java development, Git workflows, and AI agent init.
*   **Bash Configuration**: Clean `.bashrc` and `.bash_profile` supporting SDKMAN and Rancher Desktop.
*   **Kitty Terminal**: GPU-based terminal emulator configured for macOS Option-as-Alt behavior (`macos_option_as_alt yes`) and dedicated escape sequence mapping for seamless Option+Space tmux prefix navigation.
*   **LazyVim (Neovim)**: Modular, fast Neovim configuration bootstrapped from the official LazyVim starter into `~/.config/nvim`.
*   **Karabiner-Elements**: Deep, modularized keyboard modifications (e.g., option-based vim arrows `Option + H/J/K/L`, capslock tweaks, hold modifications, and mapping tilde to `F18` for Hammerspoon's hyper-key).
*   **Hammerspoon**: A modal orchestration layout (using `F18` as a trigger for application launching and space switching).
*   **Vim Configuration**: Custom `.vimrc` integrated with the Dracula Vim colorscheme (automatically cloned during setup).
*   **Tmux Configuration**: Custom `.tmux.conf` featuring `Option+Space` (`M-Space`) prefix, quick reload shortcut (`Option+Space` + `r`), vim-style pane navigation and resizing, Kitty & LazyVim color fixes, and integration with TPM (`tmux-plugins/tpm`) and `vim-tmux-navigator`.

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

To run the installation unattended (automatically accepting all package and tool installations), use the `-y` or `--yes` flag:

```bash
./install.sh -y
```

### What `install.sh` does:
1.  **Verifies Prerequisites**: Validates that `git`, `curl`, and `python3` are available before proceeding.
2.  **Backs Up Existing Configs**: Any existing configurations (e.g., `~/.zshrc`, `~/.vimrc`) are backed up inside a timestamped folder under `~/.dotfiles_backup/` so you never lose anything.
3.  **Installs Missing Packages**: Interactively prompts to install Homebrew, Neovim, ripgrep, Oh My Zsh, Kitty, LazyVim starter, `kubectx`/`kubens`, `zoxide`, `kube-ps1`, `k9s`, `tmux`, `zsh-sage` (trusted formula & tap), Karabiner-Elements, and Hammerspoon if they aren't already installed.
4.  **Compiles Karabiner Configuration**: Runs the Python compilation script to build your latest `karabiner.json` automatically from your modular rules folder.
5.  **Symlinks Dotfiles & Plugins**: Creates symbolic links from your home directories directly to this repository (including linking `zsh-sage` into Oh My Zsh custom plugins), and imports existing shell history into the `zsh-sage` database.
6.  **Vim Dracula Bootstrap**: Automatically clones the Dracula colorscheme repository directly into Vim's native package start folder (`~/.vim/pack/themes/start/dracula`).
7.  **Kitty & Tmux Bootstrap**: Automatically symlinks `~/.config/kitty/kitty.conf` and `~/.tmux.conf`, clones Tmux Plugin Manager (TPM), and initializes plugins including `vim-tmux-navigator`.

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

# Install CLI dependencies (including neovim, ripgrep, k9s, and tmux)
brew install neovim ripgrep kubectx zoxide kube-ps1 k9s tmux

# Install zsh-sage (Intelligent autosuggestions)
brew trust --formula utsavmandal2022/zsh-sage/zsh-sage
brew tap UtsavMandal2022/zsh-sage
brew install zsh-sage

# Install GUI tools (macOS only)
brew install --cask karabiner-elements hammerspoon

# Install Oh My Zsh
sh -c "$(curl -fsSL toughness/ohmyzsh/master/tools/install.sh)"

# Install Kitty terminal emulator
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# Install LazyVim starter configuration
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
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

# Link zsh-sage plugin into Oh My Zsh & import history
mkdir -p ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins
ln -sf $(brew --prefix zsh-sage) ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-sage
zsh -ic '_sage_db_import_history'
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

#### Kitty Terminal setup
```bash
# Ensure the kitty configuration directory exists
mkdir -p ~/.config/kitty

# Backup existing config if it exists
[ -f ~/.config/kitty/kitty.conf ] && mv ~/.config/kitty/kitty.conf ~/.dotfiles_backup/manual/

# Create symlink
ln -s ~/workspace/dotfiles/kitty/kitty.conf ~/.config/kitty/kitty.conf
```

#### Tmux & TPM setup
```bash
# Ensure tmux configuration is backed up
[ -f ~/.tmux.conf ] && mv ~/.tmux.conf ~/.dotfiles_backup/manual/

# Create symlink
ln -s ~/workspace/dotfiles/tmux/.tmux.conf ~/.tmux.conf

# Clone TPM (Tmux Plugin Manager) and install plugins
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux start-server && ~/.tmux/plugins/tpm/tpm && ~/.tmux/plugins/tpm/bin/install_plugins

# Reload running tmux server configuration
tmux source-file ~/.tmux.conf
```

### 3. Apply Configs

To load the shell configurations immediately:
```bash
source ~/.zshrc
```

To reload Tmux configuration without restarting active sessions:
```bash
tmux source-file ~/.tmux.conf
```
*(Or press `Option + Space` followed by `r` from within any Tmux pane).*

Make sure Karabiner-Elements and Hammerspoon are launched, and enable Accessibility permissions under **System Settings > Privacy & Security > Accessibility** for them to operate.

---

## 🪟 Tmux & Kitty Setup & Keybindings

### Option + Space Prefix on macOS
In tmux syntax, `Option` (or `Alt`) is represented as `M-` (Meta).
This configuration sets the tmux prefix to `Option + Space` (`M-Space`).

> ⚠️ **Important for Kitty on macOS**:
> By default, macOS interprets `Option + Space` as a non-breaking space (`\u00a0`) instead of Meta (`\x1b `).
> Our included `kitty.conf` handles this by setting:
> - `macos_option_as_alt yes`
> - `map alt+space send_text all \x1b\x20`
>
> If you make changes to Kitty's `macos_option_as_alt` setting, ensure you **completely quit and reopen Kitty** (`Cmd + Q`) for the option key behavior to take effect.

### Tmux Keybindings Reference

| Action | Shortcut |
| :--- | :--- |
| **Prefix Key** | `Option + Space` |
| **Last Window** | `Option + Space` then `Option + Space` |
| **Reload Config** | `Option + Space` then `r` (or `tmux source-file ~/.tmux.conf`) |
| **Split Window Horizontally** | `Option + Space` then `'` or `\` |
| **Split Window Vertically** | `Option + Space` then `-` or `=` |
| **New Window** | `Option + Space` then `c` |
| **Next Layout** | `Option + Space` then `H` |
| **Swap Pane Down / Up** | `Option + Space` then `J` / `K` |
| **Resize Pane (Repeatable)** | `Option + Space` then `Arrow Keys` (Left, Down, Up, Right) |
| **Vim Navigate Panes** | `Ctrl + h/j/k/l` (seamless across Vim and Tmux via `vim-tmux-navigator`) |
| **Vi Copy Mode** | `Option + Space` then `[` |
| ↳ Begin selection | `v` |
| ↳ Block / Rectangle toggle | `Ctrl + v` |
| ↳ Copy selection | `y` (or mouse drag release) |
| ↳ Paste buffer | `Option + Space` then `P` |

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

---

## 📄 License

This repository is licensed under the [MIT License](LICENSE). You are free to use, copy, modify, merge, publish, and distribute this software for any purpose.

