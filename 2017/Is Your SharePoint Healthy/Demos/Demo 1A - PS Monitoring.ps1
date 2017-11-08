
Get-WmiObject win32_logicaldisk `
     | Where DriveType -eq 3 | Select DeviceId, VolumeName, FreeSpace, Size `
     | ConvertTo-Html -Title "Monitoring Report" -Body "<style> td {padding: 10px }</style><h1>Harddrive Space</h1>" `
     | Out-File -FilePath c:\temp\monitoringscan.html

Start-Process "c:\temp\monitoringscan.html"

Get-WmiObject win32_logicaldisk `
     | Where DriveType -eq 3 | Select DeviceId, VolumeName, @{n='FreeSpace'; e={($_.FreeSpace/1GB).ToString(".00") + " GB"}}, @{n='TotalSize'; e={($_.Size/1GB).ToString(".00") + " GB"}} `
     | ConvertTo-Html -Title "Monitoring Report" -Body "<style> td {padding: 10px }</style><h1>Harddrive Space</h1>" `
     | Out-File -FilePath c:\temp\monitoringscan.html

Start-Process "c:\temp\monitoringscan.html"
