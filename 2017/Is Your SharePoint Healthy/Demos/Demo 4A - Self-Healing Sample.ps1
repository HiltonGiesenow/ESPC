$bitsService = Get-Service BITS

if ($bitsService.Status -ne "Running")
{
    Write-Warning "BITS Service is not running, attempting restart..."
    
    $bitsService | Start-Service #-WhatIf

    $bitsService = Get-Service BITS

    if ($bitsService.Status -ne "Running")
        { Write-Error "Could not start BITS service, operator assistance required (Send Email etc...)" }
    else
        { Write-Host "`tBITS service restarted successfully (Send Email etc...)" -ForegroundColor Green }
} else {
    Write-Host "BITS service running fine (Send Email etc...)" -ForegroundColor Green
}

# Stop-Service BITS