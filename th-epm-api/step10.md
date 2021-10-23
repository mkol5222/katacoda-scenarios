Infinity Portal AUTHORIZATION is based on JWT. JWT can be obtained via various AUTHENTICATION flows. We are covering exchanging API key for the token in this step.


### Bring your own API keys

Introduce your API key as environment variables HEP_KEY and HEP_SECRET. Replace with your real keys.

E.g.
`export HEP_KEY=610335028c194dfdb8e2f98437a7b17c`{{execute}}
`export HEP_SECRET=f1028f2b672d4338aa44c4ad09ccb94e`{{execute}}


### Authenticate using login API call

Build request payload
`REQUEST_PAYLOAD="{\"clientId\":\"$HEP_KEY\",\"accessKey\":\"$HEP_SECRET\"}"; echo "$REQUEST_PAYLOAD" | jq .`{{execute}}

Send request
`RESPONSE=$(curl -s --data-binary "$REQUEST_PAYLOAD" -H "content-type: application/json" "https://cloudinfra-gw.portal.checkpoint.com/auth/external")`{{execute}}

Check the response
`echo "$RESPONSE" | jq .`{{execute}}


### Inspecting the token

 Look for your token
 `PORTAL_TOKEN=$(echo "$RESPONSE" | jq -r .data.token); echo; echo $PORTAL_TOKEN`{{execute}}

 Interested in JWT contents? Copy and inspect in [JWT.IO Debugger](https://jwt.io/#debugger-io)


### SUMMARY
 
 You have valid PORTAL_TOKEN, if everything went well. This token confirms your Infinity Portal user identity and permissions(roles).
