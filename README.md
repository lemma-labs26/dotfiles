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
5. Dotfiles & Configuration Placement (The 4 essential config files)
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

---

## 3. ONE-LINER MASS INSTALLATION

Once WinGet is available, open a PowerShell window and run:

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
If needed add --Force and/or upgrade.

*(Alternative with Chocolatey if you prefer Choco:)*
```powershell
choco install -y powershell-core microsoft-windows-terminal alacritty nerd-fonts-jetbrainsmono starship zoxide fd ripgrep bat eza notepad3 texmaker git gh
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

Save these 4 files and copy them to their respective locations on the new computer:

### 1. PowerShell Profile
* **Target path:** `C:\Users\<username>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`
* **Contains:** PSReadLine setup, Catppuccin prompt colors, custom aliases (`e`, `tx`, `texmaker`, `reload`).

### 2. Starship Configuration
* **Target path:** `C:\Users\<username>\.config\starship.toml`
* **Contains:** Catppuccin Mocha capsules, OS symbol, Git indicators, language modules, `scan_timeout = 100`.

### 3. Windows Terminal Settings
* **Target path:** `C:\Users\<username>\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`
* **Contains:** Font (`JetBrainsMono NF`), Catppuccin Mocha color scheme, acrylic opacity, default profile set to PowerShell 7.

### 4. Alacritty Configuration
* **Target path:** `C:\Users\<username>\AppData\Roaming\alacritty\alacritty.toml`
* **Contains:** Cyberpunk 2077 Night City theme, electric cyan beam cursor, padding, and default launch command set to `pwsh.exe`.

---

## 6. CHEAT SHEET OF DAILY SHORTCUTS

| Command / Key | What it does |
| :--- | :--- |
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
