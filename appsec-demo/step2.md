
# SourceGuard - optional step

Your tenant tokens
Set your own keys similar to
`export SG_CLIENT_ID=ec4f557a-bb4b-4e90-b622-6542160c569a ; export SG_SECRET_KEY=55046b03d59e4ee4a85319d45657810c`{{execute}}

Pull Shift Left command line tool as Docker container
`docker pull checkpoint/shiftleft`{{execute}}

Clone some source code to be scanned
`git clone https://github.com/sunnyvale-it/CVE-2021-44228-PoC src`{{execute}}

Initiate scan
`docker run -ti --rm -v $(pwd)/src:/src -v$(pwd):/out -e SG_CLIENT_ID=$SG_CLIENT_ID -e SG_SECRET_KEY=$SG_SECRET_KEY checkpoint/shiftleft 'shiftleft  code-scan -s /src --json > /out/scan.json'`{{execute}}

Inspect scan.json
`cat scan.json | grep ^\{ | jq . | head`{{execute}}

And visit Infinity Portal for SourceGuard report.


