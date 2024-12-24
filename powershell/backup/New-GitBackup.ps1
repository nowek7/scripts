$DATE = Get-Date -Format "yyyy-MM-dd"

$BASE_BACKUP_DIR = "~\Dropbox\backup"
if (!(Test-Path -Path $BASE_BACKUP_DIR)) {
    New-Item -ItemType Directory -Path $BASE_BACKUP_DIR | Out-Null
}

$WINDOWS_DIR = "$BASE_BACKUP_DIR\windows\$DATE"
if (!(Test-Path -Path $WINDOWS_DIR)) {
    New-Item -ItemType Directory -Path $WINDOWS_DIR | Out-Null
}

$GIT_DIR = "$WINDOWS_DIR\git"
if (!(Test-Path -Path $GIT_DIR)) {
    New-Item -ItemType Directory -Path $GIT_DIR | Out-Null
}

$userGitFiles = Get-ChildItem -Path "$HOME" -Filter "*git*"
if ($userGitFiles.Count -gt 0) {
    $archivePath = Join-Path $GIT_DIR -ChildPath "config.zip"
    Compress-Archive -Path $userGitFiles.FullName -DestinationPath $archivePath -Force

    Write-Host "User Git-related files successfully archived to $archivePath"
} else {
    Write-Warning "No Git-related files found in $HOME"
}

