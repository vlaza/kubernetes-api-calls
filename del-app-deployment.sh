#!/bin/bash

usage()
{
cat << EOF
usage: $0 options

This script removes a Kubernestes deployment from a specific namespace.

OPTIONS:
   -h      Show this message
   -a      Application deployment name
   -n      Namespace
   -p      Container port
EOF
}

APP_DEPL_NAME=
K8S_NAMESPACE=

while getopts “h:a:n:” OPTION
do
  case $OPTION in
    h) usage; exit 1;;
    a) APP_DEPL_NAME=$OPTARG;;
    n) K8S_NAMESPACE=$OPTARG;;
    ?) usage; exit;;
  esac
done

if [[ -z $APP_DEPL_NAME ]] || [[ -z $K8S_NAMESPACE ]]
  then
    usage
    exit 1
fi

. vars

curl -k -X DELETE -H "Authorization: Bearer ${TOKEN}" -H "Content-Type: application/yaml" \
    https://$API_URL:6443/apis/extensions/v1beta1/namespaces/$K8S_NAMESPACE/deployments/$APP_DEPL_NAME

