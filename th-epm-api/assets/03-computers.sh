#!/bin/bash

PORTAL_TOKEN=$(. ./01-get-token.sh| jq -r .data.token)
EPMAAS_TOKEN=$(. ./02-epmaas-login.sh | jq -r .data.loginExternal.token)

API_URL="https://cloudinfra-gw.portal.checkpoint.com/app/endpoint-web-mgmt/webmgmt/graphql"

QUERY="
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
"

VARS="
 {
    \"paging\":  { \"offset\":  0, \"pageSize\":  100 },
    \"sorting\":  [],
    \"filter\":  [{ \"filterValues\":  \"\", \"columnName\":  \"computerName\" } ]
} 
"

BODY=$(jq -n --arg QUERY "$QUERY" --arg VARS "$VARS" '{query: $QUERY, variables: $VARS}')

curl -s --data-binary "$BODY" \
 -H "content-type: application/json" \
 -H "Authorization: Bearer $PORTAL_TOKEN" \
 -H "token: $EPMAAS_TOKEN" \
 "$API_URL"