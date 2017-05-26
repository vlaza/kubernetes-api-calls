#!/bin/bash

usage()
{
cat << EOF
usage: $0 options

This script creates a Kubernestes service inside a namespace.

OPTIONS:
   -h      Show this message
   -s      Service name
   -n      Namespace
   -l      Application label
   -p      Container port
EOF
}

K8S_NS=

while getopts “h:s:n:l:p:” OPTION
do
  case $OPTION in
    h) usage; exit 1;;
    s) SERVICE_NAME=$OPTARG;;
    n) K8S_NAMESPACE=$OPTARG;;
    l) APP_LABEL=$OPTARG;;
    p) CONTAINER_PORT=$OPTARG;;
    ?) usage; exit;;
  esac
done

if [[ -z $SERVICE_NAME ]] || [[ -z $K8S_NAMESPACE ]] || [[ -z $APP_LABEL ]] || [[ -z $CONTAINER_PORT ]]
  then
    usage
    exit 1
fi


. vars

SERVICE_TMP_YAML=$(mktemp)
cp yaml-templates/new-ext-service.yaml $SERVICE_TMP_YAML
sed -i "s/SERVICE_NAME/$SERVICE_NAME/g" $SERVICE_TMP_YAML
sed -i "s/K8S_NAMESPACE/$K8S_NAMESPACE/g" $SERVICE_TMP_YAML
sed -i "s/APP_LABEL/$APP_LABEL/g" $SERVICE_TMP_YAML
sed -i "s/CONTAINER_PORT/$CONTAINER_PORT/g" $SERVICE_TMP_YAML
curl -k -X POST -H "Authorization: Bearer ${TOKEN}" -H "Content-Type: application/yaml"\
  -d"$(cat $SERVICE_TMP_YAML)" https://$API_URL:6443/api/v1/namespaces/$K8S_NAMESPACE/services

rm -f SERVICE_TMP_YAML

