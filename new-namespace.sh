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

K8S_NS=

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

NAMESPACE_TMP_YAML=$(mktemp)
cp yaml-templates/new-namespace.yaml $NAMESPACE_TMP_YAML
sed -i "s/K8S_NAMESPACE/$K8S_NAMESPACE/g" $NAMESPACE_TMP_YAML
curl -k -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/yaml" -X POST\
  -d"$(cat $NAMESPACE_TMP_YAML)" https://$API_URL:6443/api/v1/namespaces
 
rm -f $NAMESPACE_TMP_YAML

