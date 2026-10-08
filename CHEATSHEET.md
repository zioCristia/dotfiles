# 🚀 Developer Survival Guide: Kitty, LazyVim & Tmux
*A field manual for conquering the "Vim Dip" and reaching keyboard flow state.*

---

## 🧠 Overcoming the "Vim Dip"
The **Vim Dip** is the temporary drop in productivity when switching from a mouse-driven GUI to keyboard-centric modal editing. 
* **Rule 1:** *Don't try to memorize everything at once.* Master 5–10 motions first.
* **Rule 2:** *Think in "Grammar":* `Verb + Count + Noun/Object` (e.g., `d` + `2` + `w` = delete 2 words, `c` + `i` + `"` = change inside quotes).
* **Rule 3:** *When lost, hit `<Esc>`.* Normal mode is your home base. If you don't know a keybinding, press `<Space>` in LazyVim and pause for 300ms—**Which-Key** will pop up and tell you what's possible!

---

## 🐱 1. Kitty Terminal Shortcuts

Kitty is your high-performance, GPU-accelerated terminal.

| Shortcut (macOS) | Action | Notes |
| :--- | :--- | :--- |
| <kbd>Cmd</kbd> + <kbd>Enter</kbd> | **New Kitty Window** | Splits the current window |
| <kbd>Cmd</kbd> + <kbd>W</kbd> | **Close Window / Tab** | Closes active pane or tab |
| <kbd>Cmd</kbd> + <kbd>]</kbd> / <kbd>[</kbd> | **Next / Prev Window** | Cycle between Kitty splits |
| <kbd>Cmd</kbd> + <kbd>T</kbd> | **New Kitty Tab** | Create a new tab bar entry |
| <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>]</kbd> / <kbd>[</kbd> | **Next / Prev Tab** | Switch between Kitty tabs |
| <kbd>Cmd</kbd> + <kbd>1</kbd> ... <kbd>9</kbd> | **Go to Tab 1–9** | Direct tab jump |
| <kbd>Cmd</kbd> + <kbd>+</kbd> / <kbd>-</kbd> / <kbd>0</kbd> | **Increase / Decrease / Reset Font** | Instant zoom |
| <kbd>Cmd</kbd> + <kbd>Ctrl</kbd> + <kbd>,</kbd> | **Reload Kitty Config** | Reloads `~/.config/kitty/kitty.conf` |
| <kbd>Cmd</kbd> + <kbd>Up</kbd> / <kbd>Down</kbd> | **Scroll Line Up / Down** | Fast scrollback inspection |
| <kbd>Cmd</kbd> + <kbd>PageUp</kbd> / <kbd>PageDown</kbd> | **Scroll Page Up / Down** | Jump through terminal history |

> 💡 **macOS Alt/Option Note:** Your config has `macos_option_as_alt yes` and `map alt+space send_text all \x1b\x20`, allowing `Option` to act as standard `Meta`/`Alt` for Tmux and CLI tools.

---

## 🪟 2. Tmux Cheat Sheet (Prefix: `Option + Space`)

Inside your terminal, Tmux manages persistent workspaces, panes, and windows.

| Keys | Action |
| :--- | :--- |
| <kbd>Option</kbd> + <kbd>Space</kbd> | **Prefix Key** (press before any Tmux command) |
| <kbd>Prefix</kbd> then <kbd>Option + Space</kbd> | Toggle to **last active window** |
| <kbd>Prefix</kbd> then <kbd>r</kbd> | **Reload Tmux config** (`~/.tmux.conf`) |
| <kbd>Prefix</kbd> then <kbd>\</kbd> or <kbd>'</kbd> | **Split horizontally** (new pane on right) |
| <kbd>Prefix</kbd> then <kbd>-</kbd> or <kbd>=</kbd> | **Split vertically** (new pane below) |
| <kbd>Prefix</kbd> then <kbd>c</kbd> | **New window** (tab in Tmux status bar) |
| <kbd>Prefix</kbd> then <kbd>1</kbd>–<kbd>9</kbd> | Jump directly to window number |
| <kbd>Prefix</kbd> then <kbd>z</kbd> | **Toggle Zoom** (maximize/restore current pane) |
| <kbd>Prefix</kbd> then <kbd>x</kbd> | **Kill current pane** (with confirmation) |
| <kbd>Prefix</kbd> then <kbd>Arrow Keys</kbd> | **Resize pane** by 2 rows/cols (repeatable) |
| <kbd>Prefix</kbd> then <kbd>H</kbd> | Cycle through window layouts |
| <kbd>Prefix</kbd> then <kbd>[</kbd> | **Vi Copy Mode** (scroll with `k`/`j`, `v` to select, `y` to copy) |
| <kbd>Prefix</kbd> then <kbd>P</kbd> | **Paste buffer** |

---

## ⚡ 3. The Seamless Navigation Bridge: `Ctrl + h/j/k/l`

Thanks to `vim-tmux-navigator` configured in both Tmux and LazyVim, you don't need prefixes to switch between editor splits and terminal panes!

| Shortcut | Direction |
| :--- | :--- |
| <kbd>Ctrl</kbd> + <kbd>h</kbd> | Focus **Left** (moves across Neovim splits *and* Tmux panes) |
| <kbd>Ctrl</kbd> + <kbd>j</kbd> | Focus **Down** |
| <kbd>Ctrl</kbd> + <kbd>k</kbd> | Focus **Up** |
| <kbd>Ctrl</kbd> + <kbd>l</kbd> | Focus **Right** |

---

## 🟢 4. Vim Core Grammar (Normal Mode Essentials)

Every Vim command is a combination of **Verbs**, **Counts**, and **Motions / Objects**.

### A. The 4 Modes
1. **Normal Mode (`Esc`):** Used for navigation and manipulation. Default mode.
2. **Insert Mode (`i` / `a` / `o`):** Typing text like a standard editor.
3. **Visual Mode (`v` / `V` / `Ctrl+v`):** Selecting text (character, line, or block).
4. **Command Mode (`:`):** Running editor commands (`:w` save, `:q` quit, `:qa` quit all).

### B. Entering Insert Mode (Stop using just `i`!)
* `i` : Insert **before** cursor
* `a` : Append **after** cursor
* `I` : Insert at **start** of line
* `A` : Append at **end** of line
* `o` : Open new line **below** and enter insert mode
* `O` : Open new line **above** and enter insert mode

### C. Moving Around Efficiently
* `h` / `j` / `k` / `l` : Left, Down, Up, Right
* `w` : Jump to start of **next word**
* `b` : Jump back to start of **previous word**
* `e` : Jump to **end of word**
* `0` : Jump to **absolute start** of line
* `^` : Jump to **first non-blank character** of line
* `$` : Jump to **end** of line
* `gg` : Jump to **top of file**
* `G` : Jump to **bottom of file**
* `{number}G` or `:{number}` : Jump to line number
* `%` : Jump between matching `()`, `{}`, `[]`
* `f{char}` : Jump forward to `{char}` on current line (use `;` to repeat, `,` to reverse)
* `t{char}` : Jump forward **until** `{char}` (just before it)

### D. The Magic of Text Objects (`Verb` + `Inside/Around` + `Target`)
* **Verbs:**
  * `d` = delete (cut)
  * `c` = change (delete and enter Insert mode)
  * `y` = yank (copy)
  * `v` = visually select
* **Inside (`i`) vs Around (`a`):**
  * `ci"` = Change inside `"..."` (leaves quotes intact)
  * `ca"` = Change around `"..."` (deletes quotes too)
  * `ci(` or `cib` = Change inside parentheses `(...)`
  * `ci{` or `ciB` = Change inside curly braces `{...}`
  * `ciw` = Change word under cursor
  * `diw` = Delete word under cursor
  * `yap` = Yank entire paragraph
  * `d$` or `D` = Delete to end of line
  * `C` = Change to end of line

### E. Undo, Redo, Paste
* `u` : **Undo**
* <kbd>Ctrl</kbd> + <kbd>r</kbd> : **Redo**
* `p` : **Paste after** cursor
* `P` : **Paste before** cursor
* `.` : **Repeat last edit command** (the most powerful key in Vim!)

---

## 💤 5. LazyVim Essential Workflows (`Leader = <Space>`)

In LazyVim, the **Leader key** is `<Space>`. Whenever you are in Normal mode, press `<Space>` to open the command palette.

### 🔍 A. Finding Files & Buffers
| Keys | Action |
| :--- | :--- |
| <kbd>Space</kbd> <kbd>Space</kbd> | **Find Files** (searches project root, includes `.*` dotfiles) |
| <kbd>Space</kbd> <kbd>f</kbd> <kbd>f</kbd> | **Find Files** in Project Root |
| <kbd>Space</kbd> <kbd>f</kbd> <kbd>F</kbd> | **Find Files** in Current Working Directory (cwd) |
| <kbd>Space</kbd> <kbd>f</kbd> <kbd>r</kbd> | **Recent Files** |
| <kbd>Space</kbd> <kbd>,</kbd> or <kbd>Space</kbd> <kbd>f</kbd> <kbd>b</kbd> | **Switch Open Buffer** |
| <kbd>Shift</kbd> + <kbd>h</kbd> | **Previous Buffer Tab** |
| <kbd>Shift</kbd> + <kbd>l</kbd> | **Next Buffer Tab** |
| <kbd>Space</kbd> <kbd>b</kbd> <kbd>d</kbd> | **Close Buffer** (without closing split) |

### 📂 B. File Explorer (Snacks Explorer)
| Keys | Action |
| :--- | :--- |
| <kbd>Space</kbd> <kbd>e</kbd> | **Toggle Explorer** in project root |
| <kbd>Space</kbd> <kbd>E</kbd> | **Toggle Explorer** in cwd |

#### Inside the Explorer Tree:
* `l` or `<Enter>` : Open file / Expand directory
* `h` or `<BS>` : Collapse directory / Go up a directory
* `a` : **Add new file or folder** (append `/` for directory, e.g. `src/utils/`)
* `d` : **Delete** file or folder
* `r` : **Rename** file or folder
* `c` : **Copy** file
* `m` : **Move / Cut** file
* `p` : **Paste** file
* `H` : **Toggle hidden `.*` dotfiles**
* `I` : **Toggle gitignored files** (e.g. `node_modules`, `.env`)
* `.` : Set explorer root to selected directory
* `q` or `<Esc>` : Close explorer

### 🔎 C. Searching Text (Grep & Replace)
| Keys | Action |
| :--- | :--- |
| <kbd>Space</kbd> <kbd>/</kbd> or <kbd>Space</kbd> <kbd>s</kbd> <kbd>g</kbd> | **Live Grep** across whole repository |
| <kbd>Space</kbd> <kbd>s</kbd> <kbd>w</kbd> | **Search Word** under cursor across project |
| <kbd>Space</kbd> <kbd>s</kbd> <kbd>r</kbd> | **Grug-Far (Search & Replace)** across multiple files |

### ⚡ D. Jump Anywhere with Flash
* Press **`s`**, then type **2 characters** of where you want to go.
* Flash highlights every match on screen with a single letter label.
* Press that letter, and your cursor teleports there instantly!

### 💻 E. Coding & LSP (Language Server)
| Keys | Action | Description |
| :--- | :--- | :--- |
| `g` `d` | **Go to Definition** | Jump to where function/class is declared |
| `g` `r` | **Go to References** | Show all places this symbol is used |
| `g` `I` | **Go to Implementation** | Jump to interface implementation |
| `K` | **Hover Documentation** | Show type signature / docstring in popup |
| <kbd>Space</kbd> <kbd>c</kbd> <kbd>r</kbd> | **Rename Symbol** | Project-wide refactoring rename |
| <kbd>Space</kbd> <kbd>c</kbd> <kbd>a</kbd> | **Code Action** | Quick fixes, imports, ESLint fixes |
| <kbd>Space</kbd> <kbd>c</kbd> <kbd>f</kbd> | **Format Document** | Formats code with Prettier/Stylua/LSP |
| `[` `d` / `]` `d` | **Prev / Next Diagnostic** | Jump between compiler/linter warnings & errors |
| <kbd>Space</kbd> <kbd>x</kbd> <kbd>x</kbd> | **Trouble Diagnostics** | Open project-wide error list at bottom |

### 🐙 F. Git Integration
| Keys | Action |
| :--- | :--- |
| <kbd>Space</kbd> <kbd>g</kbd> <kbd>g</kbd> | **Open Lazygit** (full terminal Git UI) |
| `]` `h` / `[` `h` | Jump to **Next / Previous Git hunk** |
| <kbd>Space</kbd> <kbd>g</kbd> <kbd>h</kbd> <kbd>p</kbd> | **Preview Hunk Diff** inline |
| <kbd>Space</kbd> <kbd>g</kbd> <kbd>h</kbd> <kbd>s</kbd> | **Stage Hunk** |
| <kbd>Space</kbd> <kbd>g</kbd> <kbd>h</kbd> <kbd>r</kbd> | **Reset / Discard Hunk** |
| <kbd>Space</kbd> <kbd>g</kbd> <kbd>h</kbd> <kbd>b</kbd> | **Git Blame Line** |

### 🪟 G. Neovim Window Management
| Keys | Action |
| :--- | :--- |
| <kbd>Ctrl</kbd> + <kbd>w</kbd> then <kbd>s</kbd> | Split window horizontally |
| <kbd>Ctrl</kbd> + <kbd>w</kbd> then <kbd>v</kbd> | Split window vertically |
| <kbd>Ctrl</kbd> + <kbd>w</kbd> then <kbd>q</kbd> | Close current split |
| <kbd>Ctrl</kbd> + <kbd>w</kbd> then <kbd>=</kbd> | Balance split window sizes evenly |

---

## 🖨️ 6. Emergency Pocket Cheat Sheet

Print this or keep it in mind whenever you feel stuck:

```
+-------------------------------------------------------------------------+
|                          LAZYVIM EMERGENCY CARD                         |
+-------------------------------------------------------------------------+
|  Stuck? Hit <Esc>!                                                      |
|  Which-Key: Hit <Space> and wait 300ms for full popup menu.             |
|                                                                         |
|  FINDING                                                                |
|    <Space><Space> : Find any file (including .* dotfiles)               |
|    <Space>/       : Search text in project (Live Grep)                  |
|    <Space>e       : Toggle File Explorer (H: hidden, I: gitignored)     |
|    Shift + h / l  : Switch between open tabs (buffers)                  |
|    <Space>bd      : Close current tab                                   |
|                                                                         |
|  NAVIGATION                                                             |
|    Ctrl + h/j/k/l : Jump seamlessly across Neovim splits & Tmux panes   |
|    s + 2 chars    : Flash jump to any word on screen                    |
|    w / b          : Next / previous word                                |
|    gg / G         : Top / bottom of file                                |
|                                                                         |
|  EDITING                                                                |
|    ci"            : Change inside "quotes"                              |
|    ciw            : Change current word                                 |
|    u / Ctrl+r     : Undo / Redo                                         |
|    .              : Repeat last action                                  |
|                                                                         |
|  CODING & LSP                                                           |
|    gd             : Go to definition                                    |
|    K              : Hover docs / type info                              |
|    <Space>cr      : Rename variable project-wide                        |
|    <Space>cf      : Format code                                         |
|    ]d / [d        : Next / previous error                               |
+-------------------------------------------------------------------------+
```
