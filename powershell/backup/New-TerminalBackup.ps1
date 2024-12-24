$DATE = Get-Date -Format "yyyy-MM-dd"

$BASE_BACKUP_DIR = "~\Dropbox\backup"
if (!(Test-Path -Path $BASE_BACKUP_DIR)) {
    New-Item -ItemType Directory -Path $BASE_BACKUP_DIR | Out-Null
}

$WINDOWS_DIR = "$BASE_BACKUP_DIR\windows\$DATE"
if (!(Test-Path -Path $WINDOWS_DIR)) {
    New-Item -ItemType Directory -Path $WINDOWS_DIR | Out-Null
}

$TERMINAL_DIR = "$WINDOWS_DIR\terminal"
if (!(Test-Path -Path $TERMINAL_DIR)) {
    New-Item -ItemType Directory -Path $TERMINAL_DIR | Out-Null
}

$terminalSettings = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path -Path $terminalSettings) {
    $archivePath = Join-Path $TERMINAL_DIR -ChildPath "settings.zip"
    Compress-Archive -Path $terminalSettings -DestinationPath $archivePath -Force
    Write-Host "Windows Terminal settings backed up to $TERMINAL_DIR"
} else {
    Write-Warning "No Windows Terminal settings file found."
}

