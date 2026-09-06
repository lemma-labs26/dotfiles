# ==============================================================================
# SICKASS POWERSHELL PROFILE
# ==============================================================================

# --- 1. PSReadLine (Predictive IntelliSense & Keybindings) ---
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine -ErrorAction SilentlyContinue

    if (-not [Console]::IsOutputRedirected) {
        # Predicción inteligente basada en historial (estilo fish/zsh)
        Set-PSReadLineOption -PredictionSource History -ErrorAction SilentlyContinue
        Set-PSReadLineOption -PredictionViewStyle InlineView -ErrorAction SilentlyContinue

        # Tecla F2 para alternar entre sugerencia en línea y lista desplegable interactiva
        Set-PSReadLineKeyHandler -Key F2 -Function SwitchPredictionView -ErrorAction SilentlyContinue

        # Menú interactivo al presionar Tab
        Set-PSReadLineKeyHandler -Chord 'Tab' -Function MenuComplete -ErrorAction SilentlyContinue

        # Búsqueda rápida en el historial con flechas Arriba/Abajo filtrando lo escrito
        Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward -ErrorAction SilentlyContinue
        Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward -ErrorAction SilentlyContinue
        Set-PSReadLineOption -HistorySearchCursorMovesToEnd

        # Paleta de colores Catppuccin Mocha
        Set-PSReadLineOption -Colors @{
            Command            = '#89B4FA'  # Azul suave
            Parameter          = '#F5C2E7'  # Rosa/Lavanda
            String             = '#A6E3A1'  # Verde
            Operator           = '#94E2D5'  # Cian/Teal
            Variable           = '#F9E2AF'  # Amarillo pastel
            Number             = '#FAB387'  # Durazno
            Member             = '#B4BEFE'  # Lavanda claro
            InlinePrediction   = '#585B70'  # Gris tenue sugerido
        } -ErrorAction SilentlyContinue
    }
}

# --- 2. Íconos en consola (Terminal-Icons) ---
if (Get-Module -ListAvailable -Name Terminal-Icons) {
    Import-Module Terminal-Icons
}

# --- 3. Zoxide (Navegación inteligente con 'z') ---
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# --- 4. Starship Prompt ---
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

# --- 5. Atajos útiles (Aliases / Helpers) ---
function reload {
    . "$PROFILE"
    Write-Host " Perfil recargado exitosamente!" -ForegroundColor Green
}

function global:e {
    eza --icons=always @args
}

function global:texmaker { & "C:\Program Files (x86)\Texmaker\texmaker.exe" @args }
function global:tx { & "C:\Program Files (x86)\Texmaker\texmaker.exe" @args }
function global:hist { & "C:\Users\moral\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" @args }

# --- 6. Gestor de Perfiles de GlazeWM ---
function global:glaze-profile {
    & "$HOME\.glzr\glazewm\profiles\glaze-profile.ps1" @args
}