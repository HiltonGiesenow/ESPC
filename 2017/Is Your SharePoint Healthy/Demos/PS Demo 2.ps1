Function Test-DriveSpace
{
    [CmdletBinding()]
    param (
        $warningPercent = 30
    )

    $driveSpaceOutput = @()

    $serverDriveSpace = Get-WmiObject win32_logicaldisk| Where DriveType -eq 3 # fixed drives only

    foreach ($drive in $serverDriveSpace)
    {
        $totalSpace = $drive.Size/1GB
        $freeSpace = $drive.FreeSpace/1GB
        $freeSpacePercent = $freeSpace / $totalSpace * 100
        $highlight = $false

        Write-Verbose ("`t`t" + $drive.DeviceID + " : " + $totalSpace.ToString(".00") + " : " + $freeSpace.ToString(".00") + " (" + $freeSpacePercent.ToString("00") + "%)")

        if ($freeSpacePercent -lt $warningPercent)
        {
            Write-Warning "`t`tFree drive Space ($("{0:N0}" -f $freeSpacePercent)%) is below variance threshold ($warningPercent%)"
            $highlight = $true
        }
      
        $driveSpaceOutput += [pscustomobject]@{
            'DriveLetter' = $drive.DeviceID;
            'TotalSpace' = $totalSpace.ToString(".00");
            'FreeSpace' = $freeSpace.ToString(".00") + " (" + $freeSpacePercent.ToString("00") + "%)";
            'Highlight' = $highlight;
        }
    }
    
    return $driveSpaceOutput
}

Function Send-MonitoringEmail
{
    [CmdletBinding()]
    param (
        [pscustomobject]$driveSpaceOutput
    )

    <#
    ...
    Send-MailMessage
    ...
    #>
}

$driveSpaceOutput = Test-DriveSpace -Verbose

Send-MonitoringEmail $driveSpaceOutput