#Requires -RunAsAdministrator

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$Version = "v1.9.25200"
)

function Install-WinGetDependencies {
    param (
        [Parameter(Mandatory=$false)]
        [string]$DownloadBaseUrl
    )

    if (-not $DownloadBaseUrl) {
        Write-Error "Base download URL is not provided."
    }

    $outputDirectory = "${env:TEMP}\DesktopAppInstaller_Dependencies"
    $outputPath = "${env:TEMP}\DesktopAppInstaller_Dependencies.zip"

    try {
        Write-Host "Downloading WinGet dependencies from ${DownloadBaseUrl}..."
        Invoke-WebRequest -Uri "${DownloadBaseUrl}/DesktopAppInstaller_Dependencies.zip" -OutFile $outputPath

        Write-Verbose "Extracting dependencies..."
        Expand-Archive -Path $outputPath -DestinationPath $outputDirectory -Force

        Write-Host "Installing WinGet dependencies packages..."
        Get-ChildItem -Path "$outputDirectory\x64\" -Recurse -Filter *.appx | ForEach-Object {
            $packageName = $_.FullName
            try {
                Add-AppxPackage -Path $packageName -ErrorAction Stop
                Write-Verbose "Successfully installed $packageName"
            } catch {
                Write-Error "Failed to install $packageName - $_"
            }
        }
    } catch {
        Write-Error "An error occurred: $_"
    } finally {
        Write-Verbose "Cleaning up temporary files..."
        if (Test-Path $outputDirectory) {
            Remove-Item $outputDirectory -Recurse -Force
        }

        if (Test-Path "$outputPath") {
            Remove-Item "$outputPath" -Force
        }
    }
}

function Install-WinGet {
    param (
        [Parameter(Mandatory = $true)]
        [string]$DownloadBaseUrl
    )

    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "WinGet is already installed."
        return
    }

    Install-WinGetDependencies -DownloadBaseUrl $DownloadBaseUrl

    # Define the path to download the installer
    $installerPath = "${env:TEMP}\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    $licensePath = "${env:TEMP}\License.xml"

    try {
        Write-Host "Downloading WinGet package..."
        Invoke-WebRequest -Uri "${DownloadBaseUrl}/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -OutFile $installerPath
        Invoke-WebRequest -Uri "${DownloadBaseUrl}/b473e86aaadc488882f8b6d7b7217117_License1.xml" -OutFile $licensePath

        Write-Host "Installing WinGet..."
        Write-Host $installerPath
        Add-ProvisionedAppxPackage -PackagePath $installerPath -LicensePath $licensePath -Online -ErrorAction Stop
        Add-AppxPackage -Path $installerPath -ErrorAction Stop

        setx.exe PATH "%PATH%;%UserProfile%\AppData\Local\Microsoft\WindowsApps\"

        # Verify installation
        if (Get-Command winget -ErrorAction SilentlyContinue) {
            Write-Host "WinGet has been successfully installed."
        } else {
            Write-Host "WinGet installation failed."
        }
    } catch {
        Write-Error "An error occurred: $_"
    } finally {
        if (Test-Path $installerPath) {
            Remove-Item $installerPath -Force
        }

        if (Test-Path $licensePath) {
            Remove-Item $licensePath -Force
        }
    }
}


$downloadBaseUrl = "https://github.com/microsoft/winget-cli/releases/download/$Version"
Install-WinGet -DownloadBaseUrl $downloadBaseUrl
