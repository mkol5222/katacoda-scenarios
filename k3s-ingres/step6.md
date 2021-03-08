Ingress

`cat ingress.yml`{{execute T3}}

Apply

`k3s kubectl apply -f ingress.yml`{{execute T3}}

Check 

`k3s kubectl describe ingress`{{execute T3}}

One more app

`k3s kubectl create deployment nginx --image=nginx`{{execute T3}}
`cat svc-nginx.yml`{{execute T3}}
`k3s kubectl apply -f svc-nginx.yml`{{execute T3}}
`k3s kubectl get pod -o wide`{{execute T3}}
`k3s kubectl get svc`{{execute T3}}


Try (check correct external IP 172.17.0.X abobe)
`curl -H "Host: example.net" 172.17.0.27/http`{{execute T3}}
`curl -H "Host: example.net" 172.17.0.27/nginx`{{execute T3}}

Notice nginx is responsing, but path prefixed /nginx does not exist on the server.
