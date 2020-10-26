
## Create checkpoint namespace

Dome9 agent application resides in dedicated Kubernetes namespace - "checkpoint" by default.

Run the following command to create it

`kubectl create namespace checkpoint`{{execute}}

Application will reside here. Notice future commands have "--namespace checkpoint" parameter where relevant.


