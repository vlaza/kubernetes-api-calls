#!/bin/bash

usage()
{
cat << EOF
usage: $0 options

This script creates a Kubernestes Deployment in specified namespace.

OPTIONS:
   -h      Show this message
   -a	   Application deployment name
   -n      Namespace
   -r      Replication factor
   -l      Application label
   -c	   Containers name
   -i      DockerHub image
   -p      Container port
EOF
}

APP_DEPL_NAME=
K8S_NAMESPACE=
REPL_FACTOR=
APP_LABEL=
CONTAINER_NAME=
SOURCE_IMAGE=
CONTAINER_PORT=

while getopts “h:a:n:r:l:c:i:p:” OPTION
do
  case $OPTION in
    h) usage; exit 1;;
    a) APP_DEPL_NAME=$OPTARG;;
    n) K8S_NAMESPACE=$OPTARG;;
    r) REPL_FACTOR=$OPTARG;;
    l) APP_LABEL=$OPTARG;;
    c) CONTAINER_NAME=$OPTARG;;
    i) SOURCE_IMAGE=$OPTARG;;
    p) CONTAINER_PORT=$OPTARG;;
    ?) usage; exit;;
  esac
done

if [[ -z $APP_DEPL_NAME ]] || [[ -z $K8S_NAMESPACE ]] || [[ -z $REPL_FACTOR ]] || [[ -z $APP_LABEL ]] || [[ -z $CONTAINER_NAME ]] || [[ -z $SOURCE_IMAGE ]] || [[ -z $CONTAINER_PORT ]]
  then
    usage
    exit 1
fi

. vars

DEPLOYMENT_TMP_YAML=$(mktemp)
cp yaml-templates/new-app-deployment.yaml $DEPLOYMENT_TMP_YAML
sed -i "s/APP_DEPL_NAME/$APP_DEPL_NAME/g" $DEPLOYMENT_TMP_YAML
sed -i "s/K8S_NAMESPACE/$K8S_NAMESPACE/g" $DEPLOYMENT_TMP_YAML
sed -i "s/REPL_FACTOR/$REPL_FACTOR/g" $DEPLOYMENT_TMP_YAML
sed -i "s/APP_LABEL/$APP_LABEL/g" $DEPLOYMENT_TMP_YAML
sed -i "s/CONTAINER_NAME/$CONTAINER_NAME/g" $DEPLOYMENT_TMP_YAML
sed -i "s#SOURCE_IMAGE#$SOURCE_IMAGE#g" $DEPLOYMENT_TMP_YAML
sed -i "s/CONTAINER_PORT/$CONTAINER_PORT/g" $DEPLOYMENT_TMP_YAML
curl -k -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/yaml" -X POST\
  -d"$(cat $DEPLOYMENT_TMP_YAML)" https://$API_URL:6443/apis/extensions/v1beta1/namespaces/$K8S_NAMESPACE/deployments
 
rm -f $DEPLOYMENT_TMP_YAML

