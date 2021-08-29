param (
[Parameter(Mandatory = $false)]
[string]$ComputerName
)
Function Jump ($ComputerName) {
& "$PSScriptRoot\files\PsExec.exe" -AcceptEula -nobanner \\$ComputerName cmd
}