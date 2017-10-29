Describe "System Drive Space" {
    It "Should have fixed disks attached" {
        $driveInfo = Get-WmiObject win32_logicaldisk | Where DriveType -eq 3
        
        @($driveInfo).Count | Should BeGreaterThan 0
    }

    It "Should have enough space on each fixed drive" {
        $driveInfo = Get-WmiObject win32_logicaldisk | Where DriveType -eq 3 | Select DeviceId, VolumeName, FreeSpace, Size

        $warningPercent = 30

        foreach ($drive in $driveInfo) {
            $totalSpace = $drive.Size/1GB
            $freeSpace = $drive.FreeSpace/1GB
            $freeSpacePercent = $freeSpace / $totalSpace * 100

            Write-Verbose ("`t`t" + $drive.DeviceID + " : " + $totalSpace.ToString(".00") + " : " + $freeSpace.ToString(".00") + " (" + $freeSpacePercent.ToString("00") + "%)")
            
            $freeSpacePercent | Should BeGreaterThan $warningPercent

        }
    }
}