Param
(
    [Parameter(HelpMessage='VM idx')][int]$VmIndex = 0,
    [Parameter(HelpMessage='Switch name')][string]$SwitchName = "SwitchName",
    [Parameter(HelpMessage='Password for VM')][securestring]$VmPassword = "Admin@12"
)

# Consts
$MB = 1024 * 1024
$MEMORY_PER_VM_MB = 11000
$VM_DIRECTORY = "D:\LiveVmFiles"
$BASE_C_DRIVE_VHD = "D:\VhdxTemplates\C_Virtual_Hard_Disk.vhdx"
$BASE_D_DRIVE_VHD = "D:\VhdxTemplates\D_Virtual_Hard_Disk.vhdx"
$PROCESSORS_PER_VM = 32

function Add-VHD {
    param (
        [string]$BaseVhd,
        [string]$VhdPath,
        [string]$DriveLetter
    )
    Write-Verbose "Creating VHD for ${DriveLetter}: $BaseVhd"
    New-VHD -ParentPath $BaseVhd -Path $VhdPath -Differencing
}

function Get-VmName {
    return "W22-V{0:d2}" -f $VmIndex
}

try
{
    $VmName = Get-VmName

    Write-Host "Starting VM creation process for $VmName with switch $SwitchName"

    $VhdCdrivePath = Join-Path -Path $VmLocation -ChildPath "$VmName`_Cdrive.vhdx"
    Add-VHD -BaseVhd $BASE_C_DRIVE_VHD -VhdPath $VhdCdrivePath -DriveLetter "C"

    $VhdDdrivePath = Join-Path -Path $VmLocation -ChildPath "$VmName`_Ddrive.vhdx"
    Add-VHD -BaseVhd $BASE_D_DRIVE_VHD -VhdPath $VhdDdrivePath -DriveLetter "D"

    # Create the VM
    Write-Host "Creating VM: $VmName"
    New-VM -Name $VmName `
           -Generation 2 `
           -Path (Join-Path -Path $VM_DIRECTORY -ChildPath $VmName) `
           -VHDPath $VhdCdrivePath `
           -MemoryStartupBytes ($MEMORY_PER_VM_MB * $MB) `
           -SwitchName $SwitchName

    Set-VM -Name $VmName -AutomaticStartAction AlwaysStart
    Set-VM -Name $VmName -AutomaticStartAction StartIfRunning -AutomaticStartDelay 30

    Write-Host "Adding D: drive"
    Add-VMHardDiskDrive -VMName $VmName -Path $VhdDdrivePath

    Write-Host "Configuring processors for $VmName"
    Set-VMProcessor -VMName $VmName -Count $PROCESSORS_PER_VM -CompatibilityForMigrationEnabled $true

    Write-Host Configuring processors
    Set-VMProcessor -VMName $VMName -Count $PROCESSORS_PER_VM -CompatibilityForMigrationEnabled $true

    Write-Host "VM $VmName created successfully!"
}
catch
{
    Write-Host "Error occurred during VM creation: $_"
    throw
}

# Attempt to change the computer name using the script
# ----------------------------------------------------

# $securePassword = ConvertTo-SecureString $VmPassword -AsPlainText -force
# $defaultVmAccount = "ND-CI-W22-V01\Administrator"
# $cred = New-Object System.Management.Automation.PsCredential($defaultVmAccount, $securePassword)

# $newComputerName = $VmName.ToUpper()
# Invoke-Command -VMName $VmName -Credential $cred -ScriptBlock { param($newComputerName, $defaultVmAccount) Rename-Computer -NewName $($newComputerName) -LocalCredential $($defaultVmAccount) }
