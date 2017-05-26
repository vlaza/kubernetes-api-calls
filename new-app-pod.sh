#!/bin/bash

usage()
{
cat << EOF
usage: $0 options

This script creates a Kubernestes Pod in specified namespace.

OPTIONS:
   -h      Show this message
   -a      Pod name
   -n      Namespace
   -l      Application label
   -c      Containers name
   -i      DockerHub image
   -p      Container port
EOF
}

POD_NAME=
K8S_NAMESPACE=
APP_LABEL=
CONTAINER_NAME=
SOURCE_IMAGE=
CONTAINER_PORT=

while getopts “h:a:n:l:c:i:p:” OPTION
do
  case $OPTION in
    h) usage; exit 1;;
    a) POD_NAME=$OPTARG;;
    n) K8S_NAMESPACE=$OPTARG;;
    l) APP_LABEL=$OPTARG;;
    c) CONTAINER_NAME=$OPTARG;;
    i) SOURCE_IMAGE=$OPTARG;;
    p) CONTAINER_PORT=$OPTARG;;
    ?) usage; exit;;
  esac
done

if [[ -z $POD_NAME ]] || [[ -z $K8S_NAMESPACE ]] || [[ -z $APP_LABEL ]] || [[ -z $CONTAINER_NAME ]] || [[ -z $SOURCE_IMAGE ]] || [[ -z $CONTAINER_PORT ]]
  then
    usage
    exit 1
fi

. vars

POD_TMP_YAML=$(mktemp)
cp yaml-templates/new-app-pod.yaml $POD_TMP_YAML
sed -i "s/POD_NAME/$POD_NAME/g" $POD_TMP_YAML
sed -i "s/K8S_NAMESPACE/$K8S_NAMESPACE/g" $POD_TMP_YAML
sed -i "s/APP_LABEL/$APP_LABEL/g" $POD_TMP_YAML
sed -i "s/CONTAINER_NAME/$CONTAINER_NAME/g" $POD_TMP_YAML
sed -i "s#SOURCE_IMAGE#$SOURCE_IMAGE#g" $POD_TMP_YAML
sed -i "s/CONTAINER_PORT/$CONTAINER_PORT/g" $POD_TMP_YAML
curl -k -X POST -H "Authorization: Bearer ${TOKEN}" -H "Content-Type: application/yaml"\
  -d"$(cat $POD_TMP_YAML)" https://$API_URL:6443/api/v1/namespaces/$K8S_NAMESPACE/pods

rm -f $DEPLOYMENT_TMP_YAML

