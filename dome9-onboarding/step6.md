
## Dome9 agent permissions for Kubernetes cluster

Run the following commands

Service account used by Dome9 agent talking to Kubernetes APIs
`kubectl create serviceaccount cp-resource-management  --namespace checkpoint`{{execute}}

Role permissions - notice read-only access to listed Kubernetes objects
`kubectl create clusterrole cp-resource-management --verb=get,list --resource=pods,nodes,services,nodes/proxy,networkpolicies.networking.k8s.io,ingresses.extensions,podsecuritypolicies.policy,roles,rolebindings,clusterroles,clusterrolebindings,serviceaccounts,namespaces`{{execute}}

Bind permissions (cluster role) to our service account
`kubectl create clusterrolebinding cp-resource-management --clusterrole=cp-resource-management --serviceaccount=checkpoint:cp-resource-management`{{execute}}

Everything is now in place to deploy our Dome9 app.
It will receive Dome9 API communication parameters and Kubernetes permissions just created.
