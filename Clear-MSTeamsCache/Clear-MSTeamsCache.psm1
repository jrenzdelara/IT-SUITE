param (
[Parameter(Mandatory = $false)]
[string]$ComputerName
)
Function Clear-MSTeamsCache ($ComputerName) {
    
    $NT = (Get-ChildItem -Path "\\$ComputerName\c$\Users" -Force | Where-Object {$_.Attributes -eq "Directory"} | Out-GridView -Title "Please select a Username from $ComputerName" -OutputMode Single).Name
    
    If($NT -eq $null){
        Throw "You did not chose a username"
    }
    
    $ScriptBlock = {
        Stop-process -name Teams -Force
        $TeamsIni = (Get-ChildItem -Path C:\Users\$using:NT\AppData\Roaming\Microsoft\Teams -Force).Name
        Remove-Item -Path C:\Users\$using:NT\AppData\Roaming\Microsoft\Teams -Force -Recurse
        $TeamsFin = (Get-ChildItem -Path C:\Users\$using:NT\AppData\Roaming\Microsoft\Teams -Force).Name 
        $TeamsIni | ForEach-Object {
            If ($_ -in $AvayaFin){
                $Status = 'Ignored'
            }
            Else {
                $Status = 'Deleted'
            }
            [PSCustomObject]@{
                Hostname = $env:COMPUTERNAME
                "Files/Folders" = $_
                Status = $Status
            }
        }    
    }    
    Invoke-Command -ComputerName $ComputerName -ScriptBlock $ScriptBlock -ThrottleLimit 10 -ErrorAction SilentlyContinue
}