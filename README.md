# ==============================================================================
# 🚀 KICKASS WORKSTATION SETUP & DOTFILES GUIDE
# ==============================================================================
# This guide contains everything needed to replicate this exact productive,
# customized, and blazing-fast terminal environment on any new Windows machine.
# ==============================================================================

## 📋 TABLE OF CONTENTS
1. Installing the Package Managers (WinGet & Chocolatey)
2. Comprehensive Software Catalog (What each tool does & why we use it)
3. One-Liner Mass Installation Commands
4. Installing PowerShell Modules
5. Dotfiles & Configuration Placement (The 5 essential configs)
6. Cheat Sheet of Daily Shortcuts

---

## 1. INSTALLING PACKAGE MANAGERS (If not preinstalled)

### A. WinGet (Windows Package Manager)
On modern Windows 10/11, WinGet comes preinstalled with the "App Installer". If you are on a fresh Windows install, clean ISO, or Enterprise edition where `winget` is missing:

* **Official Method:** Install/Update **"App Installer"** from the Microsoft Store.
* **PowerShell Method (No Microsoft Store required):**
```powershell
# Downloads and installs the latest WinGet MSIX bundle directly from GitHub
$progressPreference = 'SilentlyContinue'
$latestWingetMsix = (Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/winget-cli/releases/latest").assets | Where-Object { $_.name -like "*.msixbundle" } | Select-Object -First 1 -ExpandProperty browser_download_url
$destPath = "$env:TEMP\Microsoft.DesktopAppInstaller_latest.msixbundle"
Invoke-WebRequest -Uri $latestWingetMsix -OutFile $destPath
Add-AppxPackage -Path $destPath
Remove-Item $destPath
```

### B. Chocolatey (Secondary Package Manager)
Great backup for command-line utilities and developer binaries:
```powershell
# Run from an Administrator PowerShell window:
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

---

## 2. COMPREHENSIVE SOFTWARE CATALOG

### 🛠️ Productivity & Daily Workflow Tools
| Tool | Package ID (WinGet) | What it does & Why you need it |
| :--- | :--- | :--- |
| **`fd`** | `sharkdp.fd` | **Blazing-fast file & directory search.** Replaces slow Windows search. Multi-threaded in Rust, respects `.gitignore` so it skips cache folders, supports date filtering (`--changed-within 2d`) and batch actions (`-x rm`). |
| **`rg` (ripgrep)** | `BurntSushi.ripgrep.MSVC` | **Lightning-fast text search inside files.** Searches millions of lines of code, LaTeX chapters (`.tex`), and bibliographies (`.bib`) in milliseconds. |
| **`bat`** | `sharkdp.bat` | **Modern `cat` with superpowers.** Syntax highlighting for 200+ languages, line numbers, and shows Git modifications directly in the left gutter (`+`, `-`, `~`). |
| **`eza`** | `eza-community.eza` | **Modern `ls` replacement.** Clean grid layout, file icons natively supported (including LaTeX ``), Git repo status indicators, and no messy column clutter. |
| **`notepad3`** | `Rizonesoft.Notepad3` | **Fast lightweight code editor.** Instant startup, syntax highlighting, regex find/replace, and dark mode without replacing the native Windows Notepad. |
| **`Texmaker`** | `PascalBrachet.Texmaker` | **Full-featured LaTeX IDE.** Built-in PDF viewer with synctex support for academic writing, papers, and dissertations. |
| **`zoxide`** | `ajeetdsouza.zoxide` | **Smarter `cd` command.** Learns the directories you visit most often. Type `z diss` to instantly teleport to your deep dissertation folder from anywhere. |
| **`git`** | `Git.Git` | **Source control & version tracking.** Essential for thesis, code, and project history. |
| **`gh`** | `GitHub.cli` | **Official GitHub CLI.** Manage pull requests, clone repos, and manage GitHub SSH keys directly from the terminal. |

---

### 🎨 Terminal & Aesthetic Core
| Tool | Package ID (WinGet) | What it does & Why you need it |
| :--- | :--- | :--- |
| **PowerShell 7** | `Microsoft.PowerShell` | **Modern, cross-platform PowerShell (`pwsh`).** 10x faster than legacy Windows PowerShell 5.1, supports ANSI colors, parallel execution, and modern profiles. |
| **Windows Terminal** | `Microsoft.WindowsTerminal` | **Modern tabbed terminal.** GPU accelerated (DirectX), tabs, split panes, Catppuccin Mocha theme, and acrylic glass blur. |
| **Alacritty** | `Alacritty.Alacritty` | **Ultralight GPU terminal (OpenGL).** Zero latency, minimal memory usage, standalone single-window speed demon customized with our Cyberpunk 2077 neon theme. |
| **JetBrainsMono Nerd Font** | `DEVCOM.JetBrainsMonoNerdFont` | **Extended developer font.** Patched with thousands of icons (Git branch, OS logos, language logos, arrows, folders) essential for Starship and Terminal-Icons. |
| **Starship** | `Starship.Starship` | **Intelligent cross-shell prompt.** Displays your Git branch, staged status (`+`, `!`), Python/Node/Rust versions, execution time, and path capsules. |
| **GlazeWM** | `glzr-io.glazewm` | **Tiling Window Manager for Windows.** Automatic window splitting, dynamic workspaces (1-9), app auto-routing (Terminal -> 2, Files -> 5, Chrome -> 1), and multi-profile manager. |
| **Zebar** | `glzr-io.zebar` | **Customizable status bar for Windows.** Lightweight desktop bar displaying workspace states, clock, hardware stats, and GlazeWM integration. |

---

## 3. ONE-LINER MASS INSTALLATION

Once WinGet is available, open a PowerShell window and run:

**PowerShell**

```powershell
winget install --accept-source-agreements --accept-package-agreements -e `
  --id Microsoft.PowerShell
```
Put winget install --accept-source-agreements --accept-package-agreements -e with each of the following id's: 
- --id Microsoft.WindowsTerminal 
- --id Alacritty.Alacritty 
- --id DEVCOM.JetBrainsMonoNerdFont 
- --id Starship.Starship 
- --id ajeetdsouza.zoxide 
- --id sharkdp.fd 
- --id sharkdp.bat 
- --id eza-community.eza 
- --id BurntSushi.ripgrep.MSVC 
- --id Rizonesoft.Notepad3 
- --id PascalBrachet.Texmaker 
- --id Git.Git 
- --id GitHub.cli
- --id glzr-io.glazewm
- --id glzr-io.zebar

If needed add --Force and/or upgrade.

*(Alternative with Chocolatey if you prefer Choco:)*
```powershell
choco install -y powershell-core microsoft-windows-terminal alacritty nerd-fonts-jetbrainsmono starship zoxide fd ripgrep bat eza notepad3 texmaker git gh glazewm
```

---

## 4. INSTALLING POWERSHELL MODULES

In PowerShell 7 (`pwsh`), install the two required customization modules:

```powershell
Install-Module -Name PSReadLine, Terminal-Icons -Scope CurrentUser -Force
```

* **`PSReadLine`**: Powers predictive autocomplete (fish/zsh style), inline history matching, and colored input.
* **`Terminal-Icons`**: Adds icons to standard `Get-ChildItem` / `ls` listings.

---

## 5. DOTFILES & CONFIGURATION PLACEMENT

Save these 5 configurations and copy them to their respective locations on the new computer:

### 1. PowerShell Profile
* **Target path:** `C:\Users\<username>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`
* **Contains:** PSReadLine setup, Catppuccin prompt colors, custom aliases (`e`, `tx`, `texmaker`, `reload`), and `glaze-profile` integration.

### 2. Starship Configuration
* **Target path:** `C:\Users\<username>\.config\starship.toml`
* **Contains:** Catppuccin Mocha capsules, OS symbol, Git indicators, language modules, `scan_timeout = 100`.

### 3. Windows Terminal Settings
* **Target path:** `C:\Users\<username>\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`
* **Contains:** Font (`JetBrainsMono NF`), Catppuccin Mocha color scheme, acrylic opacity, default profile set to PowerShell 7.

### 4. Alacritty Configuration
* **Target path:** `C:\Users\<username>\AppData\Roaming\alacritty\alacritty.toml`
* **Contains:** Cyberpunk 2077 Night City theme, electric cyan beam cursor, padding, and default launch command set to `pwsh.exe`.

### 5. GlazeWM & Zebar Configuration (Tiling Window Manager + Profiles)
* **Target path:** `C:\Users\<username>\.glzr\`
* **Quick Deploy Command (from dotfiles root):**
```powershell
Copy-Item -Path .\glzr\* -Destination "$HOME\.glzr" -Recurse -Force
```
* **Contains:**
  * Active configuration (`config.yaml`) with anti-loss safety mode (`hide_method: 'hide'` + `show_all_in_taskbar: true`), auto-floating system dialogs (`#32770`), and 1-9 workspaces:
    * `1:Web` (Chrome auto-route)
    * `2:Terminal` (WindowsTerminal auto-route with focus)
    * `3:Code` (VS Code dedicated)
    * `4:Docs` (Documentation / notes)
    * `5:Files` (File Explorer auto-route with focus)
    * `6:Media` (YouTube / Spotify / comms)
    * `7-9:Work 1-3` (Sandbox workspaces for AI tools, Antigravity, ChatGPT, Cursor, notebooks)
  * Multi-profile system (`profiles/`): `experimental.yaml` (custom active safe setup), `backup.yaml` (classic stable), `factory.yaml` (official default).
  * Profile switcher and emergency rescue script (`glaze-profile.ps1`).
  * Zebar status bar preset configuration (`zebar/settings.json`).

---

## 6. CHEAT SHEET OF DAILY SHORTCUTS

| Command / Key | What it does |
| :--- | :--- |
| **`glaze-profile <perfil>`** | Switch GlazeWM config on the fly (`factory`, `backup`, `experimental`, `status`). |
| **`glaze-profile rescue`** | Emergency rescue: restores and un-hides any minimized/lost Chrome, Code, and Terminal windows. |
| **<kbd>AltGr</kbd> + <kbd>Enter</kbd>** | Launch Windows Terminal and immediately travel with focus to Workspace 2 (`Terminal`). |
| **<kbd>AltGr</kbd> + <kbd>C</kbd>** | Launch VS Code in current workspace with immediate focus. |
| **<kbd>AltGr</kbd> + <kbd>Shift</kbd> + <kbd>1..9</kbd>** | Move active window to workspace 1..9 AND travel with focus together. |
| **<kbd>AltGr</kbd> + <kbd>1..9</kbd>** | Jump to workspace 1..9 (`Web`, `Terminal`, `Code`, `Docs`, `Files`, `Media`, `Work 1-3`). |
| **<kbd>AltGr</kbd> + <kbd>H/J/K/L</kbd>** | Shift focus between tiled windows (or arrow keys). |
| **<kbd>AltGr</kbd> + <kbd>Shift</kbd> + <kbd>H/J/K/L</kbd>** | Move focused window position within current tiled layout. |
| **<kbd>AltGr</kbd> + <kbd>R</kbd>** | Enter interactive resize mode (use HJKL/arrows to resize, Enter/Esc to exit). |
| **<kbd>AltGr</kbd> + <kbd>Shift</kbd> + <kbd>Space</kbd>** | Toggle floating mode for focused window (centered). |
| **<kbd>AltGr</kbd> + <kbd>F</kbd>** | Toggle fullscreen mode. |
| **<kbd>AltGr</kbd> + <kbd>Shift</kbd> + <kbd>R</kbd>** | Hot-reload GlazeWM configuration without restarting. |
| **`e`** | Clean, icon-rich directory list with LaTeX icon support (via `eza`). |
| **`fd <query>`** | Search files and folders at light speed. |
| **`fd -e tex`** | Find all LaTeX files in the project. |
| **`fd -e aux -e log -x rm`** | Delete all LaTeX compiler temporary cache junk in one shot. |
| **`rg "<text>"`** | Search for text or citation keys inside all project files. |
| **`bat <file>`** | Pretty print file with syntax highlighting & Git diff in gutter. |
| **`z <folder_name>`** | Teleport to any folder without typing the full path (via `zoxide`). |
| **`tx <file.tex>`** | Open a document directly in Texmaker. |
| **`notepad3 <file>`** | Open in lightweight Notepad3 without touching native Notepad. |
| **`git status`** | Check Git repo state (matches your prompt's `+`, `!`, `?` icons). |
| **<kbd>Ctrl</kbd> + <kbd>R</kbd>** | Interactive reverse search through your complete persistent command history. |
| **<kbd>↑</kbd> / <kbd>↓</kbd>** | History search filtered by whatever you started typing (cursor stays at end). |
| **<kbd>F2</kbd>** | Toggle between inline prediction and interactive dropdown menu. |
| **`. $PROFILE`** | Instantly reload your profile in the current window after editing. |
