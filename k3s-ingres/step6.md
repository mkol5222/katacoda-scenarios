Ingress

`cat ingress.yml`{{execute T4}}

Apply

`kubectl apply -f ingress.yml`{{execute T4}}

Check 

`kubectl describe ingress`{{execute T4}}

One more app

`kubectl create deployment nginx --image=nginx`{{execute T4}}
`cat svc-http.yml`{{execute T4}
`kubectl apply -f svc-http.yml`{{execute T4}}
`kubectl get svc`{{execute T4}}

Try
`curl -H "Host: example.com" external-ip/http`{{execute T4}}
