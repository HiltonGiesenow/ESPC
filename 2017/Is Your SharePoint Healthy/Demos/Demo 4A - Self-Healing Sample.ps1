Get-Service BITS

Stop-Service BITS

$bitsService = Get-Service BITS

if ($bitsService.Status -ne "Running")
{
    Write-Error "BITS Service is not running, email operator etc..."    
}

if ($bitsService.Status -ne "Running")
{
    Write-Warning "BITS Service is not running, attempting restart..."
    
    $bitsService | Start-Service #-WhatIf
    $bitsService | Set-Service -StartupType Automatic #Presumably if it's meant to be running, it should be set to auto start...

    $bitsService = Get-Service BITS

    if ($bitsService.Status -ne "Running")
        { Write-Error "Could not start BITS service, operator assistance required (Send Email etc...)" }
    else
        { Write-Host "`tBITS service restarted successfully (Send Email etc...)" -ForegroundColor Green }
} else {
    Write-Host "BITS service running fine (Send Email etc...)" -ForegroundColor Green
}
