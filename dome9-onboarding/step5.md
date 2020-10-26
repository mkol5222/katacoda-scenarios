
## Dome9 API connection pameters

Modified commands take advantage of previously introduced environment variables D9KEY, D9SECRET and D9CLUSTER.

Create a CloudGuard token or use an existing one and add to your cluster secrets

`kubectl create secret generic dome9-creds --from-literal=username=${D9KEY} --from-literal=secret=${D9SECRET} --namespace checkpoint`{{execute}}

Create a configmap to hold the clusterID

`kubectl create configmap cp-resource-management-configmap --from-literal=cluster.id=${D9CLUSTER} --namespace checkpoint`{{execute}}

This is how Dome9 agents talks to Check Point Dome9. Credentials are K8S secrets, cluster ID is stored in configmap object.
Dome9 container takes advantage of them.

