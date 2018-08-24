#!/bin/bash

cd "$(dirname "$0")"

if uname -s | grep MINGW ; then
    eval $(docker-machine env --shell bash)
fi

docker exec $( docker ps | grep mongo | cut -f 1 -d ' ') /bin/bash << EOF
mongo --authenticationDatabase admin \
    --host localhost \
    -u root \
    -p cloudground \
    cloudground-spring --eval "db.createUser({user: 'cloudground', pwd: 'cloudground', roles: [{role: 'readWrite', db: 'cloudground-spring'}]});"
EOF