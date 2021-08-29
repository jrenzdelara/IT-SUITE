param (
[Parameter(Mandatory = $false)]
[string]$ComputerName
)
Function Get-InstalledApps ($ComputerName) {
    $ScriptBlock = {
        Get-CimInstance -ClassName win32_product | Select Name, Version, IdentifyingNumber| Sort-Object Name
    }
    $Execute = Invoke-Command -ComputerName $ComputerName -ScriptBlock $ScriptBlock
    $Execute | Format-Table -AutoSize 
}