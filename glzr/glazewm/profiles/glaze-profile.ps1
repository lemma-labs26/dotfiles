<#
.SYNOPSIS
    Gestor de perfiles para GlazeWM (Factory, Backup, Experimental).
.DESCRIPTION
    Permite alternar entre configuraciones de GlazeWM sin reiniciar la sesion,
    verificar el estado del perfil activo y rescatar ventanas en caso de bloqueo.
#>

param (
    [Parameter(Position = 0)]
    [string]$Action = "status"
)

$profilesDir = Join-Path $HOME ".glzr\glazewm\profiles"
$configFile  = Join-Path $HOME ".glzr\glazewm\config.yaml"
$tagFile     = Join-Path $HOME ".glzr\glazewm\current_profile.txt"

function Show-Help {
    Write-Host ""
    Write-Host "  =================================================" -ForegroundColor Cyan
    Write-Host "            GLAZEWM PROFILE MANAGER" -ForegroundColor Cyan
    Write-Host "  =================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Uso: glaze-profile <perfil|comando>" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Perfiles disponibles:" -ForegroundColor White
    Write-Host "    factory      - Configuracion original de fabrica (vanilla)" -ForegroundColor Gray
    Write-Host "    backup       - Configuracion estable documentada (1-Sept, Right Alt, Zebar)" -ForegroundColor Gray
    Write-Host "    exp / safe   - Modo Experimental Seguro (hide_method: hide, enrutamiento auto)" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Comandos utiles:" -ForegroundColor White
    Write-Host "    status       - Muestra el perfil actual y estado de GlazeWM" -ForegroundColor Gray
    Write-Host "    rescue       - Des-minimiza y trae al frente ventanas de Chrome/Code/Terminal" -ForegroundColor Magenta
    Write-Host "    help         - Muestra esta ayuda" -ForegroundColor Gray
    Write-Host ""
}

function Get-ActiveProfileName {
    if (Test-Path $tagFile) {
        return (Get-Content $tagFile -Raw).Trim()
    }
    if (Test-Path $configFile) {
        $curHash = (Get-FileHash $configFile).Hash
        foreach ($name in @("factory", "backup", "experimental")) {
            $pPath = Join-Path $profilesDir "$name.yaml"
            if ((Test-Path $pPath) -and (Get-FileHash $pPath).Hash -eq $curHash) {
                return $name
            }
        }
    }
    return "personalizado/desconocido"
}

function Invoke-Rescue {
    Write-Host "  [Rescue] Escaneando ventanas de Chrome, VS Code y Terminales..." -ForegroundColor Magenta
    
    $csharpCode = @"
    using System;
    using System.Diagnostics;
    using System.Runtime.InteropServices;
    using System.Text;

    public class GlazeRescue {
        [DllImport("user32.dll")]
        public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);
        public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

        [DllImport("user32.dll", SetLastError = true)]
        public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);

        [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
        public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

        [DllImport("user32.dll")]
        public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);

        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

        [DllImport("user32.dll")]
        public static extern bool SetForegroundWindow(IntPtr hWnd);

        [DllImport("user32.dll")]
        public static extern void SwitchToThisWindow(IntPtr hWnd, bool fAltTab);

        public static void Run() {
            EnumWindows((hwnd, lparam) => {
                uint pid;
                GetWindowThreadProcessId(hwnd, out pid);
                Process p = null;
                try { p = Process.GetProcessById((int)pid); } catch {}
                if (p == null) return true;

                string pName = p.ProcessName.ToLower();
                if (pName.Contains("chrome") || pName.Contains("code") || pName.Contains("terminal")) {
                    StringBuilder sb = new StringBuilder(256);
                    GetWindowText(hwnd, sb, 256);
                    string t = sb.ToString();
                    if (t.Length > 0) {
                        Console.WriteLine("    -> Restaurando: [" + pName + "] " + t);
                        ShowWindowAsync(hwnd, 9); // SW_RESTORE
                        ShowWindow(hwnd, 5);      // SW_SHOW
                        SwitchToThisWindow(hwnd, true);
                    }
                }
                return true;
            }, IntPtr.Zero);
        }
    }
"@

    try {
        Add-Type -TypeDefinition $csharpCode -Language CSharp -ErrorAction SilentlyContinue
        [GlazeRescue]::Run()
        Write-Host "  [Rescue] Ventanas restauradas exitosamente." -ForegroundColor Green
    }
    catch {
        Write-Host "  [Rescue] No se pudo invocar EnumWindows directamente: $_" -ForegroundColor Yellow
    }
}

switch -Regex ($Action.ToLower()) {
    "^(help|\/\?|-h|--help)$" {
        Show-Help
        return
    }

    "^(status|info|list|ls)$" {
        $cur = Get-ActiveProfileName
        $wmProc = Get-Process -Name glazewm -ErrorAction SilentlyContinue
        $wmRunning = ($null -ne $wmProc)
        
        Write-Host ""
        Write-Host "  Perfil activo en GlazeWM: " -NoNewline
        Write-Host "$cur" -ForegroundColor Cyan
        Write-Host "  Estado del proceso:       " -NoNewline
        if ($wmRunning) {
            Write-Host "Ejecutandose (PID: $($wmProc.Id))" -ForegroundColor Green
        } else {
            Write-Host "Detenido" -ForegroundColor Yellow
        }
        Write-Host "  Perfiles disponibles:     factory, backup, experimental" -ForegroundColor Gray
        Write-Host ""
        return
    }

    "^rescue$" {
        Invoke-Rescue
        return
    }

    "^(factory|default|vanilla)$" {
        $targetName = "factory"
        $targetFile = Join-Path $profilesDir "factory.yaml"
    }

    "^(backup|stable|doc|original)$" {
        $targetName = "backup"
        $targetFile = Join-Path $profilesDir "backup.yaml"
    }

    "^(exp|experimental|safe|seguro)$" {
        $targetName = "experimental"
        $targetFile = Join-Path $profilesDir "experimental.yaml"
    }

    default {
        Write-Host ""
        Write-Host "  [ERROR] Perfil desconocido: '$Action'" -ForegroundColor Red
        Show-Help
        return
    }
}

if (-not (Test-Path $targetFile)) {
    Write-Host "  [ERROR] No se encontro el archivo de perfil: $targetFile" -ForegroundColor Red
    return
}

# Backup del config actual antes de sobreescribir
if (Test-Path $configFile) {
    $ts = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupPath = "$configFile.bak_$ts"
    Copy-Item -Path $configFile -Destination $backupPath -Force
}

# Copiar el perfil elegido
Copy-Item -Path $targetFile -Destination $configFile -Force
Set-Content -Path $tagFile -Value $targetName -Force

Write-Host ""
Write-Host "  [OK] Perfil '$targetName' aplicado correctamente." -ForegroundColor Green

# Recargar GlazeWM si está corriendo
$glazeProc = Get-Process -Name glazewm -ErrorAction SilentlyContinue
if ($null -ne $glazeProc) {
    try {
        & glazewm command wm-reload-config | Out-Null
        Write-Host "  [OK] GlazeWM ha recargado su configuracion en caliente." -ForegroundColor Cyan
    } catch {
        Write-Host "  [AVISO] GlazeWM esta activo pero el comando de recarga IPC reporto un aviso." -ForegroundColor Yellow
    }
} else {
    Write-Host "  [INFO] GlazeWM no esta corriendo. El perfil se aplicara cuando inicies GlazeWM." -ForegroundColor Gray
}
Write-Host ""
