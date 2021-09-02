param (
[Parameter(Mandatory = $false)]
[string]$ComputerName
)
Function Clear-Profile ($ComputerName) {
    New-Item -Path "\\$ComputerName\c$\" -Name TEMP -ItemType Directory -Force -Confirm:$false | Out-Null
    Copy-Item -Path "$PSScriptRoot\files\DelProf2.exe" -Destination "\\$ComputerName\c$\TEMP\" -Force -Recurse -Confirm:$false
    $list = (Get-Item \\$ComputerName\c$\Users\*).Name
    $NT = $list | Out-GridView -Title "Select a Username from $ComputerName" -OutputMode Single
    $ScriptBlock = {
        $InitialProfiles = (Get-Item C:\users\*).Name
        & C:\TEMP\DelProf2.exe /id:"$using:NT" /q
        $CurrentProfiles = (Get-Item C:\users\*).Name
        $LoggedinUser = (Get-CimInstance -ClassName Win32_ComputerSystem).UserName
        $CurrentLoggedinUser = $LoggedinUser.Replace("ABBOTSFORD\","")

        $InitialProfiles | ForEach-Object {
            If ($_ -in $CurrentProfiles){
                $Wipe = "Ignored"
                If ($_ -eq $CurrentLoggedinUser ){
                    $Wipe = "In-Use"
                }
            }
            Else {
                $Wipe = "Success"
            }
            [PSCUSTOMOBJECT]@{
                Hostname = $env:COMPUTERNAME
                UserProfile = $_
                ProfileWipe = $Wipe            
            }
        }       
    }
    $Execute = Invoke-Command -ComputerName $ComputerName -ScriptBlock $ScriptBlock -ErrorAction SilentlyContinue | Select HostName, UserProfile, ProfileWipe
    $Execute | Format-Table -AutoSize
    #Cleanup
    Remove-Item -Path \\$ComputerName\c$\TEMP -Recurse -Force -Confirm:$false    
}