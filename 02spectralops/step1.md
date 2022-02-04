
## Demo draft

Get some source
`cd; git clone https://github.com/digininja/DVWA.git r2`{{execute}}

Your SpectralOps key
`export SPK="spk-<bring-your-own"`{{execute}}

Install tools
`curl -L "https://get.spectralops.io/latest/x/sh?key=$SPK" | sh`{{execute}}

Define DSN
`export SPECTRAL_DSN=https://$SPK@get.spectralops.io`{{execute}}

Scan
`cd; cd r2; $HOME/.spectral/spectral scan --ok`{{execute}}

Make more leaks
`cd; cd r2; echo "const dbUri='mongodb://guru:vpyzamu@db1/mydata'" > db2.js; git add db2.js`{{execute}}

Rescan
`cd; cd r2; $HOME/.spectral/spectral scan --ok`{{execute}}