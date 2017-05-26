#!/bin/bash
./del-app-deployment.sh -a tomcat -n test
./del-service.sh -s tomcat-service -n test
./del-app-pod.sh -a pgsql -n test
./del-service.sh -s pgsql-service -n test

./del-namespace.sh -n test

