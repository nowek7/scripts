#Requires -RunAsAdministrator

function Get-UserCredential {
    $username = Read-Host 'Enter your username (domain\username)'
    $password = Read-Host 'Enter your password' -AsSecureString

    $credential = New-Object System.Management.Automation.PSCredential($username, $password)
    return $credential
}

function New-TempDrive {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false)][pscredential]$Credential,
        [Parameter(Mandatory = $false)]$NetworkDir
    )

    try {
        New-PSDrive -Name J -PSProvider FileSystem -Root $NetworkDir -Credential $Credential -ErrorAction Stop | Out-Null
        Write-Host "Temporary J: drive was created successfully." -ForegroundColor Green
    }
    catch {
        Write-Error -Message "Failed to create temporary drive. Error: $($_.Exception.Message)"
    }
}


$credential = Get-UserCredential
New-TempDrive -Credential $credential

Write-Host "Press any key to exit the script..."
[System.Console]::ReadKey($true) | Out-Null
exit

