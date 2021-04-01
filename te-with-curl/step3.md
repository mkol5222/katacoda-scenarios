Lets build query by file hash

`TEQ=$(jq -c -n --arg sha1 "$TESHA1" --arg filename "$filename" --arg extension "$extension"  '{request: [{sha1: $sha1, file_type: $extension, file_name: $filename, features: ["te"], te: {reports: ["pdf","xml", "tar", "full_report"]}} ]}')`{{execute}}

Preview query contents
`echo $TEQ | jq .`{{execute}}

Query the server
`curl -d "$TEQ" -k -s -H "Content-type: application/json" -H "Authorization: $TEAPIKEY" https://$TESERVER/tecloud/api/v1/file/query`{{execute}}

Next we explore how to upload file, if not yet known to server by hash.
