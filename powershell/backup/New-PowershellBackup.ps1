$DATE = Get-Date -Format "yyyy-MM-dd"

$BASE_BACKUP_DIR = "~\Dropbox\backup"
if (!(Test-Path -Path $BASE_BACKUP_DIR)) {
    New-Item -ItemType Directory -Path $BASE_BACKUP_DIR | Out-Null
}

$WINDOWS_DIR = "$BASE_BACKUP_DIR\windows\$DATE"
if (!(Test-Path -Path $WINDOWS_DIR)) {
    New-Item -ItemType Directory -Path $WINDOWS_DIR | Out-Null
}

$POWERSHELL_DIR = "$WINDOWS_DIR\powershell"
if (!(Test-Path -Path $POWERSHELL_DIR)) {
    New-Item -ItemType Directory -Path $POWERSHELL_DIR | Out-Null
}

function Backup-PowershellProfiles {
    param (
        [Parameter(Mandatory=$true)][string] $DestDir
    )

    $profiles = @(
        $PROFILE.CurrentUserCurrentHost,
        $PROFILE.CurrentUserAllHosts,
        $PROFILE.AllUsersCurrentHost,
        $PROFILE.AllUsersAllHosts
    )

    foreach ($profile in $profiles) {
        if (Test-Path -Path $profile) {
            $filename = [System.IO.Path]::GetFileNameWithoutExtension((Split-Path -Leaf $profile))
            $zipPath = Join-Path -Path $DestDir -ChildPath "$filename.zip"

            Compress-Archive -Path $profile -DestinationPath $zipPath -Force
            Write-Host "Compressed and backed up: $profile to $zipPath"
        } else {
            Write-Host "Profile not found: $profile"
        }
    }
}

function Backup-PowershellModules {
    param (
        [Parameter(Mandatory=$true)][string] $DestDir
    )

    $modulesDir = "$HOME\Documents\PowerShell\Modules"
    if (Test-Path -Path $modulesDir) {
        $modulesArchivePath = Join-Path -Path $DestDir -ChildPath "Modules.zip"

        Compress-Archive -Path $modulesDir -DestinationPath $modulesArchivePath -Force
        Write-Host "Compressed and backed up: $modulesDir to $modulesArchivePath"
    } else {
        Write-Host "Modules directory not found: $modulesDir"
    }
}

function Backup-PowershellConfiguration {
    param (
        [Parameter(Mandatory=$true)][string] $DestDir
    )

    $psConfigDir = "$HOME\AppData\Local\Microsoft\PowerShell"
    if (Test-Path -Path $psConfigDir) {
        $configArchivePath = Join-Path -Path $DestDir -ChildPath "PowerShellConfig.zip"

        Compress-Archive -Path $psConfigDir -DestinationPath $configArchivePath -Force
        Write-Host "Compressed and backed up: $psConfigDir to $configArchivePath"
    } else {
        Write-Host "PowerShell configuration directory not found: $psConfigDir"
    }
}

function Backup-Powershell {
    Backup-PowershellProfiles -DestDir $POWERSHELL_DIR
    Backup-PowershellModules -DestDir $POWERSHELL_DIR
    Backup-PowershellConfiguration -DestDir $POWERSHELL_DIR
}

# -------- Main --------
Backup-Powershell

Write-Host "PowerShell settings backup completed."

