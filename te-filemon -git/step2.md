Introduce some files
- demo.doc from CP TheratWiki
`cd ~/in; curl -O https://poc-files.threat-cloud.com/demo/demo.doc`{{execute T2}}

- EICAR file
`cd ~/in; curl -O https://www.eicar.org/download/eicar_com.zip`{{execute T2}}

- Datasheet
`cd ~/in; curl -O https://www.checkpoint.com/downloads/products/sandblast-appliances-datasheet.pdf`{{execute T2}}

Upload files from dirty side

`sftp -P 2222 root@localhost:/root/files`{{execute T2}}

Password: Vpn12345

upload 1st
`put demo.doc`{{execute T2}}
2nd
`put eicar_com.zip`{{execute T2}}
and some clean
`put sandblast-appliances-datasheet.pdf`{{execute T2}}

Exit SFTP client and watch progress at Terminal 1.

Look at quarantine
`curl localhost:9999`{{execute T2}}
and at clean side
`curl localhost:8888`{{execute T2}}

Clean side is also accessible from clean side SFTP server
`sftp -P 3333 root@localhost:/root/files`{{execute T2}}
look for datasheet
`ls`{{execute T2}}
