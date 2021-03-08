Create service for our http deployment.

`cat svc-http.yml`{{execute T2}}

`k apply -f svc-http.yml`{{execute T2}}

Once service is created, check it.

`k get svc`{{execute T2}}
