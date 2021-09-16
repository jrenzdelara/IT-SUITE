param (
[Parameter(Mandatory = $false)]
[string]$ComputerName
)
Function Clear-OutlookProfile ($ComputerName) {    
    $NT = (Get-ChildItem -Path \\$ComputerName\c$\Users | Select Name | Out-GridView -OutputMode Single).Name
    $SID = (Get-ADUser $NT).SID
    IF($SID -eq $null){
        Break
    }
    
    $ScriptBlock = {
        $defaultprofilename = "Outlook"
        Remove-Item -Path Registry::"HKEY_USERS\$using:SID\SOFTWARE\Microsoft\Office\16.0\Outlook\Profiles" -Force -Recurse -ErrorVariable OutlookError
        New-Item -Path Registry::"HKEY_USERS\$using:SID\SOFTWARE\Microsoft\Office\16.0\Outlook\Profiles" -Name $defaultprofilename -Force
        If($OutlookError){
            $Status = "Error"
        }
        Else{
            $Status = "Success"
        }
        [PSCustomObject]@{
            Hostname = $env:COMPUTERNAME
            Username = $using:NT
            OutlookProfile = $defaultprofilename
            Clear = $Status
        }
    }
    
    Invoke-Command -ComputerName $ComputerName -ScriptBlock $ScriptBlock -ThrottleLimit 10 -ErrorAction SilentlyContinue | Select Hostname,UserName,OutlookProfile,Clear
}