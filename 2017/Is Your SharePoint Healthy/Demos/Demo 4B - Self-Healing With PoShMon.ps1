
Stop-Service BITS

$poShMonConfiguration = New-PoShMonConfiguration {
    OperatingSystem `
        -WindowsServices 'BITS'
}

$monitoringOutput = Invoke-OSMonitoring -PoShMonConfiguration $poShMonConfiguration -Verbose

$monitoringOutput | Select -Last 1 | ConvertTo-JSON

$repairScripts = @(
    'C:\Development\GitHub\PoShMon\PoShMon\src\Functions\PoShMon.SelfHealing.Core\Sample-Repair-WindowsServiceState.ps1'
)

Repair-Environment -PoShMonConfiguration $poShMonConfiguration -PoShMonOutputValues $monitoringOutput -RepairScripts $repairScripts -Verbose

Get-Service BITS
