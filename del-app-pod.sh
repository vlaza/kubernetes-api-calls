#!/bin/bash

usage()
{
cat << EOF
usage: $0 options

This script removes a Kubernestes Pod in specified namespace.

OPTIONS:
   -h      Show this message
   -a      Pod name
   -n      Namespace
EOF
}

POD_NAME=
K8S_NAMESPACE=

while getopts “h:a:n:” OPTION
do
  case $OPTION in
    h) usage; exit 1;;
    a) POD_NAME=$OPTARG;;
    n) K8S_NAMESPACE=$OPTARG;;
    ?) usage; exit;;
  esac
done

if [[ -z $POD_NAME ]] || [[ -z $K8S_NAMESPACE ]]
  then
    usage
    exit 1
fi

. vars

curl -k -X DELETE -H "Authorization: Bearer ${TOKEN}" -H "Content-Type: application/yaml" \
    https://$API_URL:6443/api/v1/namespaces/$K8S_NAMESPACE/pods/$POD_NAME

