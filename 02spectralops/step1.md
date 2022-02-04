
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
`cd; cd r2; $HOME/.spectral/spectral scan --ok`
