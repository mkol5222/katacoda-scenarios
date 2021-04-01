
Request part describing our file and requested investigation details remains same as for QUERY request
`TEU=$TEQ`{{execute}}

We are uploading file using multi-part request - carrying both file and JSON documenting requested actions. Server response might be stored to variable for future use.
`TEURESP=$(curl_cli -F "request=$TEU" -F "file=@$TEFILE" -k -s -H "Content-Type: multipart/form-data" https://$TESERVER/tecloud/api/v1/file/upload ); echo $TEURESP | jq .`{{execute}}

Once file is uploaded we pool server with QUERY requests, until final verict is known.
`curl -d "$TEQ" -k -s -H "Content-type: application/json" -H "Authorization: $TEAPIKEY" https://$TESERVER/tecloud/api/v1/file/query`{{execute}}

Next we explore server response and how to get forensics report.