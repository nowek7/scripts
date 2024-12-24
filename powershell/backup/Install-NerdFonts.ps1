function Install-NerdFonts {
    $fontNames = @(
        'bigblue-terminal',
        'bitstream-vera-sans-mono',
        'blex-mono',
        'caskaydia-mono',
        'caskaydia-cove',
        'code-new-roman',
        'cousine',
        'dejavu-sans-mono',
        'fira-code',
        'fira-mono',
        'hack',
        'meslo-lg'
    )

    try {
        $scriptUrl = 'https://to.loredo.me/Install-NerdFont.ps1'
        $scriptContent = Invoke-WebRequest -Uri $scriptUrl -UseBasicParsing

        if (-not $scriptContent.Content) {
            throw "Failed to download the script from $scriptUrl"
        }

        $scriptBlock = [scriptblock]::Create($scriptContent.Content)
        if (-not $scriptBlock) {
            throw "Failed to create a script block from the downloaded script."
        }

        Write-Host "Installing fonts: $($fontNames -join ', ')"
        & $scriptBlock -Name $fontNames
        Write-Host "Fonts installed successfully."
    } catch {
        Write-Error "An error occurred: $_"
    }
}

function New-ConsoleNerdFonts {
    $registryPath = "HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Console\\TrueTypeFont"

    $fonts = @(
        'BigBlueTerm437 Nerd Font',
        'BigBlueTermPlus Nerd Font',
        'BitstromWera Nerd Font',
        'BlexMono Nerd Font',
        'CaskaydiaCove Nerd Font',
        'CodeNewRoman Nerd Font',
        'DejaVuSansM Nerd Font',
        'FiraCode Nerd Font',
        'FiraMono Nerd Font',
        'FuraCode Nerd Font',
        'LiterationMono Nerd Font',
        'MesloLGMDZ Nerd Font',
        'MesloLGS Nerd Font',
        'MesloLGSDZ Nerd Font'
    )

    for($i = 0; $i -lt $fonts.count; $i++) {
        $name = "0" * ($i + 3)
        $value = $fonts[$i]
        New-ItemProperty -Path $registryPath -Name $name -Value -PropertyType String -Force
        Write-Host "Registry entry added: $registryPath\$name = $value"
    }
}

# Main
Install-NerdFonts
New-ConsoleNerdFonts
