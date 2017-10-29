Import-Module "C:\Development\GitHub\PoShMon\PoShMon\src\PoShMon.psd1" -Verbose -Force #This is only necessary if you haven't installed the module into your Modules folder, e.g. via PowerShellGallery / Install-Module

# Demo 1 - simple PoShMon
$poShMonConfiguration = New-PoShMonConfiguration { }

Invoke-OSMonitoring -PoShMonConfiguration $poShMonConfiguration -Verbose

# Demo 2 - With some settings
$poShMonConfiguration = New-PoShMonConfiguration { OperatingSystem -DriveSpaceThresholdPercent 30 }
Invoke-OSMonitoring -PoShMonConfiguration $poShMonConfiguration -Verbose

# Demo 3 - See what tests are available
Get-OSTests

# Demo 4 - Multiple failures
Stop-Service BITS

$poShMonConfiguration = New-PoShMonConfiguration { 
                            OperatingSystem `
                                -DriveSpaceThresholdPercent 30 `
                                -WindowsServices 'BITS'
                        }
Invoke-OSMonitoring -PoShMonConfiguration $poShMonConfiguration -Verbose

# Demo 5 - Even more failures, with Push notifications
$pushbulletConfig = Get-Content -Raw -Path ([Environment]::GetFolderPath("MyDocuments") + "\pushbulletconfig.json") | ConvertFrom-Json

$poShMonConfiguration = New-PoShMonConfiguration {
                            General `
                                -MinutesToScanHistory 1440
                            OperatingSystem `
                                -EventLogCodes 'Error', 'Warning' `
                                -WindowsServices 'BITS'
                            Notifications -When All {
                                <#
                                    Email `
                                    -ToAddress "SharePointTeam@Company.com" `
                                    -FromAddress "Monitoring@company.com" `
                                    -SmtpServer "EXCHANGE.COMPANY.COM" `
                                #>
                                Pushbullet `
                                    -AccessToken $pushbulletConfig.AccessToken `
                                    -DeviceId $pushbulletConfig.DeviceId
                            }
}

Invoke-OSMonitoring -PoShMonConfiguration $poShMonConfiguration -Verbose

Start-Service BITS

# Demo 5 - See what tests are available for SharePoint

Get-SPTests