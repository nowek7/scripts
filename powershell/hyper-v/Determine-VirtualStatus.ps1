param (
    [Parameter(Mandatory=$false)]
    [string]$ComputerName = "localhost"
)

$isVirtualParams = @{
    ComputerName = $ComputerName
    ClassName = "Win32_ComputerSystem"
    Property = "Model"
}

$checkVirtual = Get-CimInstance @isVirtualParams | Select-Object -ExpandProperty Model
if ($checkVirtual -like 'Virtual*') {
    return $true
} else {
    return $false
}
