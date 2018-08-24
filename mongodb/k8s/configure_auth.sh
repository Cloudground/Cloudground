#!/bin/bash

# Check for password argument
if [[ $# -eq 0 ]] ; then
    echo 'You must provide one argument for the password of the "main_admin" user to be created'
    echo '  Usage:  configure_repset_auth.sh MyPa55wd123'
    echo
    exit 1
fi

# Create the admin user (this will automatically disable the localhost exception)
echo "Creating user: 'main_admin'"
kubectl exec mongod-0 -c mongod-container -- mongo --eval 'db.getSiblingDB("admin").createUser({user:"main_admin",pwd:"'"${1}"'",roles:[{role:"root",db:"admin"}]});'
echo

echo "Creating user: 'cloudground-spring'"
kubectl exec mongod-0 -c mongod-container -- mongo -u main_admin -p "${1}" admin --eval 'db.createUser({user:"cloudground",pwd:"'"${1}"'",roles:[{role:"readWrite",db:"cloudground-spring"}]});'
echo
