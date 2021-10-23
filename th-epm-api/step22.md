Import our TH utility functions we have created for you.

`Import-Module ./app/th.psm1`{{execute}}


List functions TH module provides. We already know *New-CPPortalSession*

`Get-Command -Module th`{{execute}}

Login
`New-CPPortalSession $thKey $thSecret`{{execute}}

Query detection events


Query process
`Get-CPTHQueryProcessNameIs svchost.exe | select -ExpandProperty searchRecords | select -ExpandProperty records | select * -ExpandProperty Process | select * -ExpandProperty Base | select * -ExpandProperty ProcessReputationInfo |  select -First 1| fl`{{execute}}