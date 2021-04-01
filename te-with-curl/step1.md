
We bring TE demo file from Check Point's ThreatWiki site. Notice we choose HTTPS to avoid network inspection
`curl -k -L -O https://poc-files.threat-cloud.com/demo/demo.doc`{{execute}}

Collect data about file to feature API request

This is our file
`TEFILE=$(pwd)/demo.doc`{{execute}}

Just file part and extension
`filename=$(basename "$TEFILE"); extension="${filename##*.}"; echo "Filename: ${filename} Extension: $extension"`{{execute}}

File is identified by hash which is also our reference to investigated file
`TESHA1=$(sha1sum $TEFILE | cut -f1 -d" "); echo "file: ${TEFILE} sha1: ${TESHA1}"`{{execute}}

Next we need to describe our TE API server.
