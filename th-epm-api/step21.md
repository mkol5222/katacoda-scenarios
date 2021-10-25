Threat Hunting is authenticated by dedicated API key that is issued independently from Harmnony Endpoint EPMaaS keys.
This section is covering how to use PowerShell to query Threat Hunting.


### Using PowerShell

Make sure you finished previous step and you are in PowerShell prompt.

`$PSVersionTable`{{execute}}


### Bring your own keys

Use your own API keys obtained in Infinity Portal - Global Settings - API Keys - make sure to choose Harmony Threat Hunting as Harmony Endpoint keys are not good for this API service.

`$thKey = "7a569c5d49064f81b96fcae919fa3c06"; $thSecret = "5a6167e78849444e8233e05c438f9de4"`{{execute}}


### Login using Infinity Portal API keys

Lets declare function to login into Threat Hunting using API key. It is storing JWT as `$Script:cpPortalToken` for future calls.

`function New-CPPortalSession ($key, $secret) {
    $body = @{
        clientId  = $key;
        accessKey = $secret
    } | ConvertTo-Json
    $res = Invoke-RestMethod -Uri "https://cloudinfra-gw.portal.checkpoint.com/auth/external" -Headers @{"Content-Type" = "application/json" } -Body $body -Method Post
    $Script:cpPortalToken = $res.data.token
    return $Script:cpPortalToken
}`{{execute}}

Lets run login step
`New-CPPortalSession $thKey $thSecret`{{execute}}

And check returned token
`Write-Host $Script:cpPortalToken`{{execute}}

This token can be also copied and inspected in [JWT.IO Debugger](https://jwt.io/#debugger-io)