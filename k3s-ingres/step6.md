Ingress

`cat ingress.yml`{{execute T4}}

Apply

`kubectl apply -f ingress.yml`{{execute T4}}

Check 

`kubectl get all`{{execute T4}}

Try
`curl -H "Host: example.com" external-ip/http`{{execute T4}}
