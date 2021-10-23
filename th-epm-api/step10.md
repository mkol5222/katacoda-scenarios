# Infinity Portal Authentication

Infinity Portal AUTHORIZATION is based on JWT. JWT can be obtained via various AUTHENTICATION flows. We will cover exchanging API key for the token.

## Bring your own API keys
Introduce your API key as environment variables HEP_KEY and HEP_SECRET. Replace with your real keys.

E.g.
`export HEP_KEY=610335028c194dfdb8e2f98437a7b17c`{execute}
`export HEP_SECRET=f1028f2b672d4338aa44c4ad09ccb94e`{execute}

## Authenticate using login API call

Build request payload
`REQUEST_PAYLOAD="{\"clientId\":\"$HEP_KEY\",\"accessKey\":\"$HEP_SECRET\"}"`{execute}

Send request
`RESPONSE=$(curl -s --data-binary "$REQUEST_PAYLOAD" -H "content-type: application/json" "https://cloudinfra-gw.portal.checkpoint.com/auth/external")`{execute}

 Look for your token
 `TOKEN=$(echo "$RESPONSE" | jq -r .data.token); echo $TOKEN`{execute}
 