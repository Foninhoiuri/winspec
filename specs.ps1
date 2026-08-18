# ============================================
# winspec - neofetch-style specs para Windows
# Pode ser executado com: iex (Invoke-WebRequest -Uri 'sua-url/specs.ps1').Content
# ============================================

$ErrorActionPreference = 'SilentlyContinue'

# ---------- Coleta de dados ----------
$os     = Get-CimInstance Win32_OperatingSystem
$cs     = Get-CimInstance Win32_ComputerSystem
$cpu    = Get-CimInstance Win32_Processor | Select-Object -First 1
$board  = Get-CimInstance Win32_BaseBoard
$disks  = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | Sort-Object DeviceID
$batt   = Get-CimInstance Win32_Battery

$uptimeSpan = (Get-Date) - $os.LastBootUpTime
$uptimeStr  = "{0}d {1}h {2}m" -f $uptimeSpan.Days, $uptimeSpan.Hours, $uptimeSpan.Minutes

$totalRAM = [math]::Round($cs.TotalPhysicalMemory / 1GB, 1)
$freeRAM  = [math]::Round($os.FreePhysicalMemory * 1KB / 1GB, 1)
$usedRAM  = [math]::Round($totalRAM - $freeRAM, 1)
$ramPct   = [math]::Round(($usedRAM / $totalRAM) * 100)

# ----- CPU: nome limpo -----
$cpuName = ($cpu.Name -replace '\(R\)', '' -replace '\(TM\)', '' -replace '\s{2,}', ' ').Trim()

# ----- GPU: prioriza adaptadores físicos (PCI), ignora virtuais (Parsec/RDP/Basic Render) -----
$gpuAll      = Get-CimInstance Win32_VideoController
$gpuPhysical = $gpuAll | Where-Object { $_.PNPDeviceID -like 'PCI\*' -and $_.Name -notmatch 'Basic Render' }
$gpuList     = if ($gpuPhysical) { $gpuPhysical } else { $gpuAll }

# ----- Motherboard -----
$boardStr = "$($board.Manufacturer) $($board.Product)".Trim()
if (-not $boardStr) { $boardStr = 'N/A' }

# ----- Rede -----
$netAdapter = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true } | Select-Object -First 1
$localIP  = if ($netAdapter -and $netAdapter.IPAddress) { $netAdapter.IPAddress[0] } else { 'N/A' }
$publicIP = 'N/A'
try {
    $publicIP = (Invoke-RestMethod -Uri 'https://api.ipify.org' -TimeoutSec 2)
} catch {}

# ----- Pacotes instalados (registro) -----
$uninstallPaths = @(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
)
$pkgCount = (Get-ItemProperty -Path $uninstallPaths -ErrorAction SilentlyContinue |
    Where-Object { $_.DisplayName } |
    Select-Object -Property DisplayName -Unique).Count

# ----- Terminal -----
$terminal = if ($env:WT_SESSION) { 'Windows Terminal' }
            elseif ($env:TERM_PROGRAM) { $env:TERM_PROGRAM }
            else { 'Console Host' }

# ----- Resolução (todos os monitores) -----
$resolution = 'N/A'
try {
    Add-Type -AssemblyName System.Windows.Forms
    $screens = [System.Windows.Forms.Screen]::AllScreens
    $resolution = ($screens | ForEach-Object { "$($_.Bounds.Width)x$($_.Bounds.Height)" }) -join ', '
} catch {}

$title = "$($env:USERNAME)@$($env:COMPUTERNAME)"

$infoLines = @(
    @{ Label = 'OS';          Value = "$($os.Caption) [$($os.OSArchitecture)]" }
    @{ Label = 'Host';        Value = "$($cs.Manufacturer) $($cs.Model)".Trim() }
    @{ Label = 'Motherboard'; Value = $boardStr }
    @{ Label = 'Kernel';      Value = "$($os.Version) (Build $($os.BuildNumber))" }
    @{ Label = 'Uptime';      Value = $uptimeStr }
    @{ Label = 'Packages';    Value = "$pkgCount (registry)" }
    @{ Label = 'Shell';       Value = "PowerShell $($PSVersionTable.PSVersion)" }
    @{ Label = 'Terminal';    Value = $terminal }
    @{ Label = 'Resolution';  Value = $resolution }
    @{ Label = 'CPU';         Value = $cpuName }
)

$gpuIndex = 1
foreach ($g in $gpuList) {
    $label = if ($gpuList.Count -gt 1) { "GPU $gpuIndex" } else { 'GPU' }
    $infoLines += @{ Label = $label; Value = $g.Name }
    $gpuIndex++
}

$infoLines += @{ Label = 'Memory'; Value = "$usedRAM GiB / $totalRAM GiB ($ramPct%)" }

foreach ($d in $disks) {
    $dTotal = [math]::Round($d.Size / 1GB, 1)
    $dUsed  = [math]::Round(($d.Size - $d.FreeSpace) / 1GB, 1)
    $dPct   = if ($dTotal -gt 0) { [math]::Round(($dUsed / $dTotal) * 100) } else { 0 }
    $infoLines += @{ Label = "Disk ($($d.DeviceID))"; Value = "$dUsed GB / $dTotal GB ($dPct%)" }
}

$infoLines += @{ Label = 'Local IP';  Value = $localIP }
$infoLines += @{ Label = 'Public IP'; Value = $publicIP }

if ($batt) {
    $infoLines += @{ Label = 'Battery'; Value = "$($batt.EstimatedChargeRemaining)% ($($batt.Status))" }
}

# ---------- Logo (bandeira do Windows: 4 quadrantes sólidos) ----------
# Usa blocos cheios (█) em vez de letras, porque caracteres como 'l' não
# preenchem sólido em todas as fontes do console e o brilho colava os dois
# lados no meio, formando um "H" em vez da bandeira.
$block = [char]0x2588
$qw    = 15   # largura de cada quadrante
$gap   = '   '
$fullBlock  = $block.ToString() * $qw

$logo = @(
    @{ Blank = $true }
    @{ Left = $fullBlock; LeftColor = 'Red';  Right = $fullBlock; RightColor = 'Green' }
    @{ Left = $fullBlock; LeftColor = 'Red';  Right = $fullBlock; RightColor = 'Green' }
    @{ Left = $fullBlock; LeftColor = 'Red';  Right = $fullBlock; RightColor = 'Green' }
    @{ Left = $fullBlock; LeftColor = 'Red';  Right = $fullBlock; RightColor = 'Green' }
    @{ Left = $fullBlock; LeftColor = 'Red';  Right = $fullBlock; RightColor = 'Green' }
    @{ Left = $fullBlock; LeftColor = 'Red';  Right = $fullBlock; RightColor = 'Green' }
    @{ Blank = $true }
    @{ Left = $fullBlock; LeftColor = 'Blue'; Right = $fullBlock; RightColor = 'Yellow' }
    @{ Left = $fullBlock; LeftColor = 'Blue'; Right = $fullBlock; RightColor = 'Yellow' }
    @{ Left = $fullBlock; LeftColor = 'Blue'; Right = $fullBlock; RightColor = 'Yellow' }
    @{ Left = $fullBlock; LeftColor = 'Blue'; Right = $fullBlock; RightColor = 'Yellow' }
    @{ Left = $fullBlock; LeftColor = 'Blue'; Right = $fullBlock; RightColor = 'Yellow' }
    @{ Left = $fullBlock; LeftColor = 'Blue'; Right = $fullBlock; RightColor = 'Yellow' }
    @{ Blank = $true }
)

$logoWidth = $qw * 2 + $gap.Length + 3

# ---------- Renderização estilo neofetch ----------
$labelWidth = (($infoLines | ForEach-Object { $_.Label.Length }) | Measure-Object -Maximum).Maximum

$rightLines = @()
$rightLines += @{ Text = $title; IsTitle = $true }
$rightLines += @{ Text = ('-' * $title.Length); IsTitle = $false; IsSep = $true }
foreach ($item in $infoLines) {
    $rightLines += @{ Label = $item.Label; Value = $item.Value }
}

$maxLines = [Math]::Max($logo.Count, $rightLines.Count)

for ($i = 0; $i -lt $maxLines; $i++) {
    if ($i -lt $logo.Count -and -not $logo[$i].Blank) {
        $row = $logo[$i]
        Write-Host $row.Left -ForegroundColor $row.LeftColor -NoNewline
        Write-Host $gap -NoNewline
        Write-Host $row.Right -ForegroundColor $row.RightColor -NoNewline
        Write-Host '   ' -NoNewline
    } else {
        Write-Host (' ' * $logoWidth) -NoNewline
    }

    if ($i -lt $rightLines.Count) {
        $r = $rightLines[$i]
        if ($r.IsTitle) {
            Write-Host $r.Text -ForegroundColor White
        } elseif ($r.IsSep) {
            Write-Host $r.Text -ForegroundColor DarkGray
        } else {
            Write-Host ($r.Label.PadRight($labelWidth)) -ForegroundColor Cyan -NoNewline
            Write-Host " : " -ForegroundColor DarkGray -NoNewline
            Write-Host $r.Value -ForegroundColor White
        }
    } else {
        Write-Host ''
    }
}

# ---------- Paleta de cores ----------
Write-Host ''
$colorRow1 = 'Black', 'DarkRed', 'DarkGreen', 'DarkYellow', 'DarkBlue', 'DarkMagenta', 'DarkCyan', 'Gray'
$colorRow2 = 'DarkGray', 'Red', 'Green', 'Yellow', 'Blue', 'Magenta', 'Cyan', 'White'

Write-Host (' ' * $logoWidth) -NoNewline
foreach ($c in $colorRow1) { Write-Host '   ' -BackgroundColor $c -NoNewline }
Write-Host ''
Write-Host (' ' * $logoWidth) -NoNewline
foreach ($c in $colorRow2) { Write-Host '   ' -BackgroundColor $c -NoNewline }
Write-Host ''
Write-Host ''
