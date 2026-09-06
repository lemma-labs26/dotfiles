# GlazeWM portable keymap

`Mod` means Right Alt on this Windows machine. On an i3, Sway, or Hyprland
configuration, the same command grammar can be assigned to Super.

| Action | Binding |
| --- | --- |
| Focus left/down/up/right | `Mod+H/J/K/L` or `Mod+Arrow` |
| Move window left/down/up/right | `Mod+Shift+H/J/K/L` or `Mod+Shift+Arrow` |
| Focus workspace 1-9 | `Mod+1-9` |
| Send window to workspace 1-9 | `Mod+Shift+1-9` |
| Previous/next active workspace | `Mod+PageUp/PageDown` |
| Recent workspace | `Mod+Tab` |
| Move workspace between monitors | `Mod+Shift+A/F/D/S` |
| Terminal | `Mod+Enter` |
| Resize mode | `Mod+R`, then HJKL/arrows; Enter/Escape exits |
| Fullscreen / floating / tiling | `Mod+F` / `Mod+Shift+Space` / `Mod+T` |
| Cycle focus states / tiling direction | `Mod+Space` / `Mod+V` |
| Minimize / close | `Mod+M` / `Mod+Shift+Q` |
| Pause GlazeWM | `Mod+Shift+P` |
| Reload / redraw / exit | `Mod+Shift+R/W/E` |

The configuration contains `Right Alt+Ctrl` aliases because the installed
US-International layout reports Right Alt as AltGr. Left Alt is intentionally
unbound and remains available to applications.
