#!/bin/bash
##
# Script to connect to the first Mongod instance running in a container of the
# Kubernetes StatefulSet, via the Mongo Shell, to initalise a MongoDB Replica
# Set and create a MongoDB admin user.
#
# IMPORTANT: Only run this once all 3 StatefulSet mongod pods are shown with
# status running (to see pod status run: $ kubectl get all)
##

# Initiate MongoDB Replica Set configuration
echo "Configuring the MongoDB Replica Set"
kubectl exec mongod-0 -c mongod-container -- mongo --eval 'rs.initiate({_id: "MainRepSet", version: 1, members: [ {_id: 0, host: "mongod-0.mongodb-service.default.svc.cluster.local:27017"}, {_id: 1, host: "mongod-1.mongodb-service.default.svc.cluster.local:27017"}, {_id: 2, host: "mongod-2.mongodb-service.default.svc.cluster.local:27017"} ]});'
echo

# Wait for the MongoDB Replica Set to have a primary ready
echo "Waiting for the MongoDB Replica Set to initialise..."
kubectl exec mongod-0 -c mongod-container -- mongo --eval 'while (rs.status().hasOwnProperty("myState") && rs.status().myState != 1) { print("."); sleep(1000); };'
#sleep 2 # Just a little more sleep to ensure everything is ready!
sleep 20 # More sleep to ensure everything is ready! (3.6.0 workaround for https://jira.mongodb.org/browse/SERVER-31916 )
echo "...initialisation of MongoDB Replica Set completed"
echo
