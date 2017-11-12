Import-Module PoShMon

# Demo 1 - simple PoShMon
Invoke-OSMonitoring -Verbose

# Demo 2 - With some settings
$poShMonConfiguration = New-PoShMonConfiguration { OperatingSystem -DriveSpaceThresholdPercent 30 }
Invoke-OSMonitoring -Verbose -PoShMonConfiguration $poShMonConfiguration 

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

$testOutput = Invoke-OSMonitoring -PoShMonConfiguration $poShMonConfiguration -Verbose

Start-Service BITS

# Demo 5 - See what tests are available for SharePoint and Office Online Server (nee OWA)

Get-SPTests
Get-OOSTests

# Demo 6 - Sample from the docs for a full SharePoint farm scan

$poShMonConfiguration = New-PoShMonConfiguration {
    General `
        -EnvironmentName 'SharePoint' `
        -MinutesToScanHistory 1440 `
        -PrimaryServerName 'SPAPPSVR01' `
        -ConfigurationName SpFarmPosh `
        -TestsToSkip ""
    OperatingSystem `
        -EventLogCodes "Error","Warning"
    WebSite `
        -WebsiteDetails @{ 
                            "http://intranet" = "Read our terms"
                            "http://extranet.company.com" = "Read our terms"
                         }
    Notifications -When OnlyOnFailure {
        Email `
            -ToAddress "SharePointTeam@Company.com" `
            -FromAddress "Monitoring@company.com" `
            -SmtpServer "EXCHANGE.COMPANY.COM" `
    }
    
}



 # | ConvertTo-Json -Depth 3