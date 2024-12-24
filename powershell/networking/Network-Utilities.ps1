function Get-MACAddress {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [string]$InterfaceAlias,

        [Parameter(Mandatory=$false)]
        [string]$ComputerName = "localhost"
    )

    if ($PSBoundParameters.ContainsKey('ComputerName')) {
        try {
            $MACCIMSession = New-CimSession -ComputerName $ComputerName -Name MACCIMSession -ErrorAction Stop
            (Get-NetAdapter -InterfaceAlias $InterfaceAlias -CimSession $MACCIMSession).MacAddress
            Remove-CimSession -Name MACCIMSession
        }
        catch {
            Write-Error "Unable to connect to remote computer. Exiting..." -ErrorAction Stop
        }
    }
    else {
        (Get-NetAdapter -InterfaceAlias $InterfaceAlias).MacAddress
    }
}

function Get-DefaultIPAddress {
    $routePrintResult = route print
    $ipv4TableStart = $false

    $routeObjects = foreach ($line in $routePrintResult) {
        if ($line -like '*Active Routes:*') {
            $ipv4TableStart = $true
            continue
        }

        if ($ipv4TableStart -and $line -like 'Network Destination*') {
            continue
        }
        # end of table
        if ($ipv4TableStart -and $line.Trim() -eq '') {
            break
        }

        if ($ipv4TableStart) {
            # Split the line into columns
            $columns = $line -split '\s+' | Where-Object { $_ }

            # Create a custom object with the route details
            if ($columns.Count -ge 5) {
                [PSCustomObject]@{
                    Destination = $columns[0]
                    Netmask     = $columns[1]
                    Gateway     = $columns[2]
                    Interface   = $columns[3]
                    Metric      = [int]$columns[4]
                }
            }
        }
    }

    # Find the route with the lowest metric as that should be the mgmt ip address
    $mgmtIPAddress = $routeObjects | Sort-Object Metric | Select-Object -First 1
    return $mgmtIPAddress.Interface
}
