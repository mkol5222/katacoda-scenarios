This is your first step.

## Task

This is an _example_ of creating a scenario and running a **command**

`echo 'Hello World'`{{execute}}


Bring your own secrets
`export D9KEY=xxx`{{execute}}
`export D9SECRET=xxx`{{execute}}
`export D9CLUSTER=xxx`{{execute}}

Run the following command (only for new namespace)

`kubectl create namespace checkpoint`{{execute}}

Create a CloudGuard token or use an existing one and add to your cluster secrets

`kubectl create secret generic dome9-creds --from-literal=username=${D9KEY} --from-literal=secret=${D9SECRET} --namespace checkpoint`{{execute}}

Create a configmap to hold the clusterID

`kubectl create configmap cp-resource-management-configmap --from-literal=cluster.id=${D9CLUSTER} --namespace checkpointz`{{execute}}

Run the following commands

`kubectl create serviceaccount cp-resource-management  --namespace checkpoint`{{execute}}

`kubectl create clusterrole cp-resource-management --verb=get,list --resource=pods,nodes,services,nodes/proxy,networkpolicies.networking.k8s.io,ingresses.extensions,podsecuritypolicies.policy,roles,rolebindings,clusterroles,clusterrolebindings,serviceaccounts,namespaces`{{execute}}

`kubectl create clusterrolebinding cp-resource-management --clusterrole=cp-resource-management --serviceaccount=checkpoint:cp-resource-management`{{execute}}

Deploy CloudGuard agent

`kubectl create -f https://secure.dome9.com/v2/assets/files/cp-resource-management.yaml --namespace checkpoint`{{execute}}