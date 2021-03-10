
Your tenant tokens
Set your own keys similar to
`export SG_CLIENT_ID=ec4f557a-bb4b-4e90-b622-6542160c569a ; export SG_SECRET_KEY=55046b03d59e4ee4a85319d45657810c`{{execute T1}}

Pull Shift Left command line tool as Docker container
`docker pull checkpoint/shiftleft`{{execute T1}}

Clone some source code to be scanned
`git clone https://github.com/mkol5222/sbport.git src`{{execute T1}}

Initiate scan
`docker run -ti --rm -v $(pwd)/src:/src -e SG_CLIENT_ID=$SG_CLIENT_ID -e SG_SECRET_KEY=$SG_SECRET_KEY checkpoint/shiftleft shiftleft  code-scan -s /src --json > scan.json`{{execute T1}}

Inspect scan.json
`cat scan.json | grep ^\{ | jq . | head`{{execute T1}}

And visit Infinity Portal for SourceGuard report.


