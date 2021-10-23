Import our TH utility functions we have created for you.

`Import-Module ./app/th.psm1`{{execute}}


List functions TH module provides. We already know *New-CPPortalSession*

`Get-Command -Module th`{{execute}}

Login
`New-CPPortalSession $thKey $thSecret`{{execute}}

Query top process list
`Get-CPTHQueryProcessNameExists | select -ExpandProperty searchRecords | select -ExpandProperty records | select -ExpandProperty Base | Group-Object ProcessName | Sort-Object Count -Descending | select Count,Name`{{execute}}

Query process args
`Get-CPTHQueryProcessNameIs "svchost.exe" | select -ExpandProperty searchRecords | select -ExpandProperty records | select -ExpandProperty Process | Group-Object ProcessArgs | Sort-Object Count -Descending | select Count,Name`{{execute}}

Query by parent process
`Get-CPTHQueryParentProcessNameIs "explorer.exe" | select -ExpandProperty searchRecords | select -ExpandProperty records | select -ExpandProperty Base | Group-Object ProcessName | Sort-Object Count -Descending | select Count,Name`{{execute}}

Network activity
`Get-CPTHQueryNetworkProcessNameIs "chrome.exe" | select -ExpandProperty searchRecords | select -ExpandProperty records | select -ExpandProperty Network | Group-Object NetworkDestIP,NetworkDestPort | Sort-Object Count -Descending | select Count,Name`{{execute}}

File activity
`Get-CPTHQueryFileProcessNameIs "svchost.exe" | select -ExpandProperty searchRecords | select -ExpandProperty records | select -ExpandProperty File | ft FileOp, FileDir, FileName`{{execute}}


