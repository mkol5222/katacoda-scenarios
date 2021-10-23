EPMaaS application  requires explocit creation of management server session. Once you have Infinity Portal token, EPMaaS session is opened by EPMaaS GraphQL call.


### Assuming valid Infinity Portal token

Infinity portal token was obtained in previus step and is stored in PORTAL_TOKEN environment variable. Check it.
`echo; echo $PORTAL_TOKEN`{{execute}}


### Creating EPMaaS Session using GraphQL API

Multiple components are required for session creation.

Knowing location of EPMaaS GraphQL API.

`API_URL="https://cloudinfra-gw.portal.checkpoint.com/app/endpoint-web-mgmt/webmgmt/graphql"`{{execute}}

GraphQL query - what exact action should be done.

`QUERY="query Login { loginExternal { token apiVersion isReadOnly frontVersion serverVersionInfo { majorVersion takeNumber hotFixVersions __typename } __typename } }"`{{execute}}

GraphQL query can be parametrized by arguments provided in *variables* part, but loginExternal already knows who we are from JTW for Infinity Portal sent in *Authorization* header. So body has only *query* part.

`BODY=$(jq -n --arg QUERY "$QUERY" '{query: $QUERY}')`{{execute}}

Actual API call:

`RESPONSE=$(curl -s --data-binary "$BODY" -H "content-type: application/json" -H "Authorization: Bearer $PORTAL_TOKEN" "$API_URL"); echo; echo "$RESPONSE" | jq .`{{execute}}

### EPMaaS Session token

We are interested in EPMaaS session token. Lets store it for later.

`EPMAAS_TOKEN=$(echo $RESPONSE | jq -r .data.loginExternal.token); echo; echo "$EPMAAS_TOKEN"`{{execute}}

### SUMMARY

We have created EPMaaS session identified by EPMAAS_TOKEN stored as environment variable. All furure EPMaaS API requests require both tokens - `PORTAL_TOKEN` in *Authorization* header and `EPMAAS_TOKEN` in *token* header.