
## Dome9 - Kubernetes cluster on-boarding - cluster.id

Continue in Dome9 portal / Asset management / On-boarding / Kubernetes

Enter
* cluster name
* API key and secret from previous steps (choose or select "manual")
* keep default Kubernetes namespace for Dome9 agent - checkpoint
* select just compliance

Next step
* choose top level org unit offered

Next step
* under second step command Deploy the agent look for cluster.id in text

E.g. in command
`helm install asset-mgmt checkpoint/cp-resource-management
   --set-string credentials.user=xxx
   --set-string credentials.secret=xxx
   --set-string clusterID=bbde9881-ba83-4c42-b246-f82a6f1ae25c
   --namespace checkpoint --create-namespace
`

cluster id is under part *clusterID=bbde9881-ba83-4c42-b246-f82a6f1ae25c*

Modify and run command:
* `export D9CLUSTER=xxx`{{execute}}
by replacing xxx with real cluster.id generated for you by on-boarding dialog similar to *bbde9881-ba83-4c42-b246-f82a6f1ae25c*

Check your environment (API key and cluster ID):
`env | grep D9`{{execute}}

