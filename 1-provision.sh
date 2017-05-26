#!/bin/bash
./new-namespace.sh -n test
./new-app-pod.sh -a pgsql -n test -l pgsql -c pgsql -i zeding/alpine-postgresql:latest -p 5432
./new-cluster-service.sh -s pgsql-service -n test -l pgsql -p 5432
./new-app-deployment.sh -a tomcat -n test -r 2 -l tomcat -c tomcat -i zeding/alpine-tomcat:latest -p 8080
./new-ext-service.sh -s tomcat-service -n test -l tomcat -p 8080

