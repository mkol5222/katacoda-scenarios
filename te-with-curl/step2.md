
We are going to use TE cloud emulation service. Access and quota is controlled via API key.
You should get your own based on API SKU in Check Point User Center.

`TEAPIKEY=TE_API_KEY_O54cnvD0G7Va3Lb2ZqnLAvt6Y9so03ywmcO32p5o`{{execute}}

We are using TE cloud service. This might be also private local TE appliance.
`TESERVER=te.checkpoint.com`{{execute}}

Summary of API server
`echo "${TESERVER}: ${TEAPIKEY}`{{execute}}

Query license quota
`curl -s -H "Content-type: application/json" -H "Authorization: $TEAPIKEY" https://$TESERVER/tecloud/api/v1/file/quota`{{execute}}