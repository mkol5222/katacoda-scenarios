
Download source code
`curl -O https://gist.githubusercontent.com/mkol5222/c336e19b18ea69c0fe1c635ac613dd76/raw/59b78ffffe8257bb79bebb325640e970048c41c5/techeck3.go`{{execute}}

Get dependencies
`go get github.com/utahta/go-openuri`{{execute}}

Build
`go build techeck3.go`{{execute}}

Run to see instructions
`./techeck3`{{execute}}

Malware sample
`TESTFILE="http://poc-files.threat-cloud.com/demo/demo.doc"`{{execute}}

Query
`./techeck3 -f ${TESTFILE} | jq .`{{execute}}

Upload
`./techeck3 -f ${TESTFILE} --upload | jq .`{{execute}}

Query again
`./techeck3 -f ${TESTFILE} | jq .`{{execute}}