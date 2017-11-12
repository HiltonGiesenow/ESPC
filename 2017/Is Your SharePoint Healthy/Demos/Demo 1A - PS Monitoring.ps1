
Get-WmiObject Win32_LogicalDisk `
     | Where DriveType -eq 3 | Select DeviceId, VolumeName, FreeSpace, Size `
     | ConvertTo-Html -Title "Monitoring Report" -Body "<style> td {padding: 10px }</style><h1>Harddrive Space</h1>" `
     | Out-File -FilePath c:\temp\monitoringscan.html

Start-Process "c:\temp\monitoringscan.html"

Get-WmiObject Win32_LogicalDisk `
     | Where DriveType -eq 3 | Select DeviceId, VolumeName, @{n='FreeSpace'; e={($_.FreeSpace/1GB).ToString(".00") + " GB"}}, @{n='TotalSize'; e={($_.Size/1GB).ToString(".00") + " GB"}} `
     | ConvertTo-Html -Title "Monitoring Report" -Body "<style> td {padding: 10px }</style><h1>Harddrive Space</h1>" `
     | Out-File -FilePath c:\temp\monitoringscan.html

Start-Process "c:\temp\monitoringscan.html"

Get-WmiObject Win32_PhysicalMemory | Select DeviceLocator, ConfiguredClockSpeed, Capacity, Manufacturer

Get-SPDatabase

$jobHistoryEntries = (Get-SPFarm).TimerService.JobHistoryEntries | Where-Object { $_.Status -eq "Failed" -and $_.StartTime -gt $StartDate }