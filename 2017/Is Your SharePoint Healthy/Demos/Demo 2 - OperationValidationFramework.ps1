Invoke-Pester "C:\Development\GitHub\ESPC\2017\Is Your SharePoint Healthy\Demos\OVF Demo\Diagnostics\Simple"

Get-OperationValidation

Copy-Item "C:\Development\GitHub\ESPC\2017\Is Your SharePoint Healthy\Demos\OVF Demo" `
            -Destination "C:\Program Files\WindowsPowerShell\Modules\" -Recurse

Get-OperationValidation

Invoke-OperationValidation

Remove-Item "C:\Program Files\WindowsPowerShell\Modules\OVF Demo" -Recurse -ErrorAction SilentlyContinue