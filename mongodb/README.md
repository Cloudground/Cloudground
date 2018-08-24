
## Kubernetes

#### Minikube

Start:  
`minikube --cpus 4 --memory 4096 start`  
Open Dashboard:  
`minikube dashboard`  
Use Docker daemon from Minikube: 
`eval $(minikube docker-env)`

Open service exposed via NodePort or LoadBalancer(not supported on Minikube):  
`minikube service mongo-express-service [--url]`

##### Kubernetes API proxy

- `kubectl proxy --port=8082`
- `http://localhost:8080/api/v1/namespaces/default/pods`
- `http://localhost:8082/api/v1/namespaces/default/services/mongo-express-service`

## MongoDB

Source: http://pauldone.blogspot.com/2017/06/deploying-mongodb-on-kubernetes-gke25.html  
(*note why not to use sidecars from* https://github.com/cvallance/mongo-k8s-sidecar/tree/master/example/StatefulSet )
Source repo: https://github.com/pkdone/minikube-mongodb-demo (there is also repo for GCE and Azure)

#### MongoDB replica set

Is actually a cluster definition. The configuration is master(PRIMARY) - slave(SECONDARY).

RSH to any Mongo pod: `kubectl exec -ti mongod-0 bash`  
Login to Mongo shell: `mongo -u main_admin -p cloudground admin`  
Get ReplicaSet(Mongo ReplicaSet - MRS) status: `rs.status()`

#### TODO:
Check operators:
- https://www.kubestack.com/catalog/mongodb

**Note**: If you scale a StatefulSet with 3 replicas to 1, the cluster will go to read-only state, if the pod which stays alive was not PRIMARY.
As the majority is down, the election process will not start.  
To reconfigure the MRS to a standalone server, execute in Mongo shell of the single alive pod:
```
cfg = rs.conf()
printjson(cfg) # check the current MRS member index
cfg.members = [cfg.members[0]] # keep only current MRS member
rs.reconfig(cfg, {force : true})
```
If you want to remove the node from MRS, execute:
```
cfg = rs.conf() 
printjson(cfg) # check the node hostname
rs.remove('<hostname>', {force: true})
```
Source: https://docs.mongodb.com/manual/tutorial/reconfigure-replica-set-with-unavailable-members/

**Note**: It is not possible (did not find an easy way) to connect to MRS from outside the cluster, as to connect from outside you need to use the NodePort,
and when you use it, the hostnames (VM IP) does not match the hostnames specified in MRS, which leads to disconnect of MongoClient