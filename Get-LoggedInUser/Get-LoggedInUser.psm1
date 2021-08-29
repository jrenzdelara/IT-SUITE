param (
[Parameter(Mandatory = $false)]
[string]$ComputerName
)
Function Get-LoggedInUser ($ComputerName) {
    $Scriptblock = {
        $NT = (Get-CimInstance -ClassName win32_Computersystem).UserName
        If ($NT -eq $null){
            $User = "N/A"
        }
        Else{
            $User = $NT
        }
        [PSCUSTOMOBJECT]@{
            Hostname = $env:COMPUTERNAME
            UserName = $User
        }
    }
    $Execute = Invoke-Command -ComputerName $ComputerName -ScriptBlock $Scriptblock -ErrorAction SilentlyContinue
    $Execute | Format-Table -AutoSize
}