#Requires -RunAsAdministrator

[CmdletBinding()]
param (
    [Parameter(Mandatory)][string]$YamlFile
)

function Get-AppsFromYamlFile {
    param (
        [string]$YamlFile
    )

    $apps = @()
    if (Test-Path $YamlFile) {
        Write-Host "Parsing YAML file: $(Get-ChildItem $YamlFile | Select-Object -ExpandProperty Name)"

        try {
            # YAML expected format:
            # app:
            #   name: <application name>
            #   id: <application id>
            #   version: <number|latest>
            $lines = Get-Content $YamlFile
            $currentApp =  @{}


            for ($i = 0; $i -lt $lines.Count; $i = $i + 5) {
                if ($lines[$i + 1] -match "^\s*name:\s*(.+)$") {
                    $appName = $matches[1].Trim()
                    $currentApp["name"] = $appName
                }

                if ($lines[$i + 2] -match "^\s*id:\s*(.+)$" -and $currentApp) {
                    $id = $matches[1].Trim()
                    $currentApp["id"] = $id
                }

                if ($lines[$i + 3] -match "^\s*version:\s*(.+)$" -and $currentApp) {
                    $version = $matches[1].Trim()
                    $currentApp["version"] = $version
                }

                $apps += $currentApp
                $currentApp = @{}
            }

            return $apps
        } catch {
            Write-Error "Failed to parse YAML file: $YamlFile"
            exit 1
        }
    } else {
        Write-Error "YAML file not found: $YamlFile"
        exit 1
    }
}

function Test-App {
    param (
        [Parameter(Mandatory)][string]$Id
    )

    $output = winget list --id $Id | Select-String -Pattern $Id
    if ($output) {
        return $true
    } else {
        return $false
    }
}

function Install-App {
    param (
        [string]$Name,
        [string]$Id,
        [string]$Version
    )

    Write-Host "Installing $Name for all users..." -ForegroundColor Green

    $versionOpt = ""
    if (-not ($Version -eq "latest")) {
        $versionOpt = "--version $Version"
    }

    winget install --exact --id $Id $versionOpt `
                   --scope machine --silent `
                   --accept-source-agreements --accept-package-agreements

    if ($LASTEXITCODE -eq 0) {
        Write-Host "$Name installed successfully." -ForegroundColor Cyan
    } else {
        winget install --exact --id $Id
        if ($LASTEXITCODE -eq 0) {
            Write-Host "$Name installed successfully." -ForegroundColor Green
        } else {
            Write-Host "$Failed to install $($Name)" -ForegroundColor Cyan
        }
    }
}

function Install-Apps(
    [array]$Apps
) {
    $totalApps = $Apps.Count
    $i = 1
    foreach ($app in $Apps) {
        if (Test-App -Id $app["id"]) {
            continue
        }

        Write-Progress -Activity "Installing Applications" `
                       -PercentComplete (($i / $totalApps) * 100)

        Install-App -Name $app["name"] -Id $app["id"] -Version $app["version"] -ErrorAction Stop

        $i++
    }

    Write-Progress -Activity "Installation Complete" -Status "All apps have been installed for all users." -Completed
    Write-Host "All selected software installations for all users are complete." -ForegroundColor Green
}

# Ensure that the script runs with administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You need to run this script as Administrator."
    exit
}

if (-not $YamlFile) {
    Write-Error "You must provide a YAML file with apps to install."
    exit 1
}

# Check if winget is installed
if (-not (Get-Command "winget" -ErrorAction SilentlyContinue)) {
    Write-Host "winget is not installed. Please install Windows Package Manager (winget) first." -ForegroundColor Red
    exit
}

$apps = Get-AppsFromYamlFile -YamlFile $YamlFile -ErrorAction Stop
Install-Apps -Apps $apps -ErrorAction Stop



