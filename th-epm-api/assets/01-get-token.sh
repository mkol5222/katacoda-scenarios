#!/bin/bash

curl -s --data-binary \
 "{\"clientId\":\"$HEP_KEY\",\"accessKey\":\"$HEP_SECRET\"}" \
 -H "content-type: application/json" \
 "https://cloudinfra-gw.portal.checkpoint.com/auth/external" 

