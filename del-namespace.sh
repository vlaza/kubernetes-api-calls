#!/bin/bash

usage()
{
cat << EOF
usage: $0 options

This script creates a Kubernestes namespace.

OPTIONS:
   -h      Show this message
   -n      Namespace
EOF
}

K8S_NAMESPACE=

while getopts “h:n:” OPTION
do
  case $OPTION in
    h) usage; exit 1;;
    n) K8S_NAMESPACE=$OPTARG;;
    ?) usage; exit;;
  esac
done

if [[ -z $K8S_NAMESPACE ]]
  then
    usage
    exit 1
fi

. vars

curl -k -X DELETE -H "Authorization: Bearer ${TOKEN}" -H "Content-Type: application/yaml" \
    https://$API_URL:6443/api/v1/namespaces/$K8S_NAMESPACE

