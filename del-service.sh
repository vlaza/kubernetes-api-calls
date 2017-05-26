#!/bin/bash

usage()
{
cat << EOF
usage: $0 options

This script removes a Kubernestes service from specified namespace.

OPTIONS:
   -h      Show this message
   -s      Service name
   -n      Namespace
EOF
}

SERVICE_NAME=
K8S_NAMESPACE=

while getopts “h:s:n:” OPTION
do
  case $OPTION in
    h) usage; exit 1;;
    s) SERVICE_NAME=$OPTARG;;
    n) K8S_NAMESPACE=$OPTARG;;
    ?) usage; exit;;
  esac
done

if [[ -z $SERVICE_NAME ]] || [[ -z $K8S_NAMESPACE ]]
  then
    usage
    exit 1
fi

. vars

curl -k -X DELETE -H "Authorization: Bearer ${TOKEN}" -H "Content-Type: application/yaml" \
    https://$API_URL:6443/api/v1/namespaces/$K8S_NAMESPACE/services/$SERVICE_NAME

