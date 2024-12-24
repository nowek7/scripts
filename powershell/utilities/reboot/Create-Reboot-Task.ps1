function New-ScheduledRebootTask {
    $action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument '-File "C:\Tools\Restart-Computer.ps1"'
    $trigger = New-ScheduledTaskTrigger -Weekly -WeeksInterval 4 -DaysOfWeek Saturday -At 12:00AM
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

    Register-ScheduledTask -Action $action `
                           -Trigger $trigger `
                           -Principal $principal `
                           -Settings $settings `
                           -TaskName "MonthlyReboot" -Description "Restarts the computer every 4 weeks on Saturday at midnight" `
                           -TaskPath 'Tools'

    if (!(Test-Path -Path "C:\Tools")) {
        New-Item -ItemType Directory -Path "C:\Tools"
    }

    Copy-Item -Path ".\Restart-Computer.ps1" -Destination "C:\Tools\" -Force -ErrorAction Stop
}

New-ScheduledRebootTask

