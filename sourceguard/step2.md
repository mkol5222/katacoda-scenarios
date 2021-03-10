CloudGuard ShiftLeft also covers scan of container images.
This is how it works.

Pull some image to be scanned
`docker pull debian:stretch-20191224`{{execute T1}}

And make it ready for scan in local file
`docker save debian:stretch-20191224 > debian_stretch-20191224.tar`{{execute T1}}

We need other set of credentials from CloudGuard portal
`export CGKEY=your-key; export CGSEC=your-secret`{{execute T1}}

Scan now
`docker run -ti --rm -v $(pwd)/debian_stretch-20191224.tar:/img/debian_stretch-20191224.tar -e CHKP_CLOUDGUARD_ID=$CGKEY -e CHKP_CLOUDGUARD_SECRET=$CGSEC checkpoint/shiftleft shiftleft  image-scan -t 900 -i /img/debian_stretch-20191224.tar`{{execute T1}}
