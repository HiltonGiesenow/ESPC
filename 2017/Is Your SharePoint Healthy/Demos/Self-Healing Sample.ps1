$bitsService = Get-Service BITS

if ($bitsService.Status -ne "Running")
{
    Write-Warning "BITS Service is not running, attempting restart..."
    
    $bitsService | Start-Service #-WhatIf

    $bitsService = Get-Service BITS

    if ($bitsService.Status -ne "Running")
        { Write-Error "Could not start BITS service, operator assistance required (SEND NOTIFICATION NOW...)" }
    else
        { Write-Host "`tBITS service restarted successfully (SEND NOTIFICATION NOW...)" -ForegroundColor Green }
} else {
    Write-Host "BITS service running fine (SEND NOTIFICATION NOW...)" -ForegroundColor Green
}

# Stop-Service BITS