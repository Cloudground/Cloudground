#!/bin/bash

mongo --authenticationDatabase admin \
    --host localhost \
    -u root \
    -p cloudground \
    cloudground-spring --eval "db.createUser({user: 'cloudground', pwd: 'cloudground', roles: [{role: 'readWrite', db: 'cloudground-spring'}]});"