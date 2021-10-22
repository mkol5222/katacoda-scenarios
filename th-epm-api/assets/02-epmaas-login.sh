#!/bin/bash

PORTAL_TOKEN=$(. ./01-get-token.sh| jq -r .data.token)

API_URL="https://cloudinfra-gw.portal.checkpoint.com/app/endpoint-web-mgmt/webmgmt/graphql"

QUERY="
    query Login {
        loginExternal {
          token
          apiVersion
          isReadOnly
          frontVersion
          serverVersionInfo {
            majorVersion
            takeNumber
            hotFixVersions
            __typename
          }
          __typename
        }
      }
"

BODY=$(jq -n --arg QUERY "$QUERY" '{query: $QUERY}')


curl -s --data-binary "$BODY" \
 -H "content-type: application/json" \
 -H "Authorization: Bearer $PORTAL_TOKEN" \
 "$API_URL"