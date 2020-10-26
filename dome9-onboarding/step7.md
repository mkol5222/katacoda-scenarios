
## Dome9 agent deployment

Deploy CloudGuard agent. Deloyment is documented in YAML file
You may preview it also [here](https://gist.github.com/mkol5222/b9e1099626ef228d4529e991d73820f7).

Run application deployment
`kubectl create -f https://secure.dome9.com/v2/assets/files/cp-resource-management.yaml --namespace checkpoint`{{execute}}

Check status by listing all objects of our Dome9 agent app

`kubectl get all -n checkpoint`{{execute}}

Check Dome9 agent logs document (hopefully) successful communication with both Kubernetes API and Dome9 portal
`kubectl logs deployment.apps/cp-resource-management -n checkpoint`{{execute}}

Your cluster is now sucessfully on-boarded. Continue in Dome9 portal.