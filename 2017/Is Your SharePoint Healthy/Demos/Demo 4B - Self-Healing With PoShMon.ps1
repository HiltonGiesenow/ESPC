#Import-Module "C:\Development\GitHub\PoShMon\PoShMon\src\PoShMon.psd1" -Verbose -Force #This is only necessary if you haven't installed the module into your Modules folder, e.g. via PowerShellGallery / Install-Module

Stop-Service BITS

$poShMonConfiguration = New-PoShMonConfiguration {
    OperatingSystem `
        -WindowsServices 'BITS'
}

$monitoringOutput = Invoke-OSMonitoring -PoShMonConfiguration $poShMonConfiguration -Verbose

$monitoringOutput

$monitoringOutput[5]

$monitoringOutput[5].OutputValues

$repairScripts = @(
    'C:\Development\GitHub\PoShMon\PoShMon\src\Functions\PoShMon.SelfHealing.Core\Sample-Repair-WindowsServiceState.ps1'
)

$repairs = Repair-Environment -PoShMonConfiguration $poShMonConfiguration -PoShMonOutputValues $monitoringOutput -RepairScripts $repairScripts -Verbose

Get-Service BITS
