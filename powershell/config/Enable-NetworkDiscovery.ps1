#Requires -RunAsAdministrator

function Enable-NetworkDiscovery {
    netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
    Write-Host 'Network Discovery is enabled'
}

Enable-NetworkDiscovery
