#Requires -RunAsAdministrator

$taskPath = '\Microsoft\Windows\Windows Defender'
$taskName = 'Windows Defender Scheduled Scan'
$scanTime = '20:00:00' # 8:00 PM

Write-Host "Enabling Windows Defender Scheduled Scans..."
try {
    $time = New-ScheduledTaskTrigger -Daily -At $scanTime
    Set-ScheduledTask -TaskPath $taskPath -TaskName $taskName -Trigger $time -ErrorAction Stop
} catch {
    Write-Error "Failed to configure Windows Defender Scheduled Scan task: $_"
}

Write-Host "Configure MpPreferences..."
Set-MpPreference -CheckForSignaturesBeforeRunningScan 1
Set-MpPreference -MAPSReporting 1
Set-MpPreference -CloudBlockLevel 4
Set-MpPreference -CloudExtendedTimeout 50
