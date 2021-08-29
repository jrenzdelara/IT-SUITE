Function Import-PS7 {
    $PS7 = Test-Path -Path "C:\Users\$env:USERNAME\Documents\PowerShell\Modules"
    If ($PS7 -eq $False){
        New-Item -Name Modules -Path "C:\Users\$env:USERNAME\Documents\PowerShell\" -ItemType Directory -Force -Confirm:$false | Out-Null
    }
    Else{$_}
    $files = Get-ChildItem "$PSScriptRoot\*" | Where-Object {$_.Name -ne "($MyInvocation.MyCommand).Name"}
    foreach ($file in $files){
        $Exclude = "Import.ps1"
        Copy-Item -Path $file -Destination "C:\Users\jrenzdelara\Documents\PowerShell\Modules\" -Exclude $Exclude -Force -Recurse -Confirm:$false
    }
    Start-Sleep -Milliseconds 750
    $Modules = (Get-Item -Path "C:\Users\$env:USERNAME\Documents\PowerShell\Modules\*" | Where-Object {$_.Attributes -eq "Directory"}).FullName
    $Modules | ForEach-Object {
        Import-Module "$_" -Force -Verbose
    }
}

Function Import-PS6Lower {
    $PS6 = Test-Path -Path "C:\Users\$env:USERNAME\Documents\WindowsPowerShell\Modules"
    If ($PS6 -eq $False){
        New-Item -Name Modules -Path "C:\Users\$env:USERNAME\Documents\WindowsPowerShell\" -ItemType Directory -Force -Confirm:$false | Out-Null
    }
    Else{$_}
    $files = Get-ChildItem "$PSScriptRoot\*" | Where-Object {$_.Name -ne "($MyInvocation.MyCommand).Name"}
    foreach ($file in $files){
        $Exclude = "Import.ps1"
        Copy-Item -Path $file -Destination "C:\Users\jrenzdelara\Documents\WindowsPowerShell\Modules\" -Exclude $Exclude -Force -Recurse -Confirm:$false
    }
    Start-Sleep -Milliseconds 750
    $Modules = (Get-Item -Path "C:\Users\$env:USERNAME\Documents\WindowsPowerShell\Modules\*" | Where-Object {$_.Attributes -eq "Directory"}).FullName
    $Modules | ForEach-Object {
        Import-Module "$_" -Force -Verbose
    }
}

Import-PS6Lower
Import-PS7