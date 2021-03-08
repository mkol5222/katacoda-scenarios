Ingress

`cat ingress.yml`{{execute T4}}

Apply

`kubectl apply -f ingress.yml`{{execute T4}}

Check 

`kubectl describe ingress`{{execute T4}}

One more app

`kubectl create deployment nginx --image=nginx`{{execute T4}}
`cat svc-nginx.yml`{{execute T4}
`kubectl apply -f svc-nginx.yml`{{execute T4}}
`kubectl get svc`{{execute T4}}

Try (check correct external IP 172.17.0.X abobe)
`curl -H "Host: example.com" 172.17.0.27/http`{{execute T4}}
