Infinity Portal AUTHORIZATION is based on JWT. JWT can be obtained via various AUTHENTICATION flows. We are covering exchanging API key for the token in this step.


### Bring your own API keys

Introduce your API key as environment variables HEP_KEY and HEP_SECRET. Replace with your real keys.

E.g.
`export HEP_KEY=19d094473f0e444184ae9a6d0840549b`{{execute}}
`export HEP_SECRET=e96473787bf54d97af13c3a053a9d669`{{execute}}


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
