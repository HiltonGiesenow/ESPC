
# Demo 1 - simple PoShMon
Invoke-OSMonitoring -Verbose

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
                                -ServerNames 'HGXPS' `
                                -MinutesToScanHistory 1440
                            OperatingSystem `
                                -EventLogCodes 'Error', 'Warning' `
                                -WindowsServices 'BITS'
                            Notifications -When None {
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

$testOutput = Invoke-OSMonitoring -PoShMonConfiguration $poShMonConfiguration -Verbose

$testOutput[3] | ConvertTo-Json -Depth 6

Start-Service BITS

# Demo 5 - See what tests are available for SharePoint

Get-SPTests