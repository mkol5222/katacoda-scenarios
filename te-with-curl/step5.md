Query response includes section with reports per each sandbox image used
`curl -d "$TEQ" -k -s -H "Content-type: application/json" -H "Authorization: $TEAPIKEY" https://$TESERVER/tecloud/api/v1/file/query`{{execute}}

We may list reports using JQ query to focus on relevant section
`curl -d "$TEQ" -k -s -H "Content-type: application/json" -H "Authorization: $TEAPIKEY" https://$TESERVER/tecloud/api/v1/file/query | jq '.response[0].te.images[].report'`{{execute}}

This results to list of download IDs similar to output below. Reports are generated only for malicious verdicts.
```
{
  "verdict": "malicious",
  "full_report": "ee076319-4425-4bb6-8293-a26b91b9f5a8",
  "pdf_report": "5b69af83-55a6-47b2-b065-0f5a6aafff88",
  "xml_report": "b5046beb-dcae-4613-a039-c179c3c0da6b"
}
{
  "verdict": "malicious",
  "full_report": "fbb3114f-e04e-4b05-bb28-aad21da782c9",
  "pdf_report": "a1ccb7fb-71c0-4e2a-b134-2b51880c4b65",
  "xml_report": "0900a7e1-2f80-4169-8906-ee031c59c519"
}
```

Assume we got malicious verdict on first image. Get download ID.
`REPID=$(curl -d "$TEQ" -k -s -H "Content-type: application/json" -H "Authorization: $TEAPIKEY" https://$TESERVER/tecloud/api/v1/file/query | jq -r '.response[0].te.images[0].report.xml_report'); echo "report download ID ${REPID}"`{{execute}}`

This is how we request XML report with sandboxing session details:
`curl -s -H "Content-type: application/json" -H "Authorization: $TEAPIKEY" "https://$TESERVER/tecloud/api/v1/file/download?id=${REPID}" -o report.xml`{{execute}}

Lets have a look into it:
`less report.xml`{{execute}}

We have finished tour through TE API use from command-line here.