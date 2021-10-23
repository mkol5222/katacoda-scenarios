We have obtained Infinity Portal token *PORTAL_TOKEN* and created new EPMaaS server session identified by EPMAAS_TOKEN. 
This section is covering calling Endpoint server API calls using these credentials.


### Assuming valid tokens

Lets inspect our credentials.

Infinity Portal token
`echo; echo $PORTAL_TOKEN`{{execute}}

And token identifying EPMaaS server session
`echo; echo $EPMAAS_TOKEN`{{execute}}


### EPMaaS API call preparation

API endpoint of GraphQL remains always same.

`API_URL="https://cloudinfra-gw.portal.checkpoint.com/app/endpoint-web-mgmt/webmgmt/graphql"`{{execute}}

Desired action or data query is described in GraphQL query part.

`QUERY="
     query computers(\$filter: [Filter], \$paging: Paging, \$computersToExclude: [String], \$groupsToExclude: [String], \$sorting: [Sorting]) {
        computers(filter: \$filter, paging: \$paging, computersToExclude: \$computersToExclude, groupsToExclude: \$groupsToExclude, sorting: \$sorting) {
          totalCount pageSize pageOffset
          computers {
            computerId computerName computerIP computerClientVersion computerDeployTime
            computerLastErrorCode computerLastErrorDescription
            computerLastConnection computerLastLoggedInUser computerLastLoggedInPrebootUser
            computerFdeStatus computerFdeVersion computerFdeWilWolStatus computerFdeWilWolStatusUpdatedOn computerFdeLastRecoveryDate
            computerFdeTpmStatus computerFdeTpmVersion computerFdeTpmId
            computerFdeProgress
            computerType
            computerCapabilities { onlyInstalledAndRun onlyInstalled }
            computerGroups { name id }
            computerDeploymentStatus amUpdatedOn
            osName osVersion daInstalled
          }
        }
      }
"`{{execute}}

GraphQL variables control specific arguments like paging with first entry to return and limiting maximum number of entries returned. It also allows to choose sorting and filter by specific column(attribute) like computerName.

`VARS="
 {
    \"paging\":  { \"offset\":  0, \"pageSize\":  100 },
    \"sorting\":  [],
    \"filter\":  [{ \"filterValues\":  \"\", \"columnName\":  \"computerName\" } ]
} 
"`{{execute}}

Lets review complete GraphQL reqest body.

`BODY=$(jq -n --arg QUERY "$QUERY" --arg VARS "$VARS" '{query: $QUERY, variables: $VARS}'); echo; echo "$BODY" | jq -r .`{{execute}}


### EPMaaS API request

Notice how our credentials are sent in HTTP request. PORTAL_TOKEN in *Authorization* header and EPMaaS session token EPMAAS_TOKEN in header called *token*.

`RESPONSE=$(curl -s --data-binary "$BODY" \
 -H "content-type: application/json" \
 -H "Authorization: Bearer $PORTAL_TOKEN" \
 -H "token: $EPMAAS_TOKEN" \
 "$API_URL"); \
 echo; echo "$RESPONSE" | jq -r .`{{execute}}


### Reading response

Response part *data* contains requested information in case of succesful request. Lets focus on first *computers* entry using `jq`

Section is named by our query - *computers* and it contains the list and paging control related fields.
`echo "$RESPONSE" | jq -r '.data.computers | keys'`{{execute}}

Computers is array (indexed by number)
`echo "$RESPONSE" | jq -r '.data.computers.computers | keys'`{{execute}}

Lets get first one
`echo "$RESPONSE" | jq -r '.data.computers.computers[0]'`{{execute}}


### SUMMARY

We have all ingredients to call EPMaaS APU with both credentials (for Infinity Portal and EPMaaS server sessions).
GraphQL schema is telling us what can be done on EPMaaS server.