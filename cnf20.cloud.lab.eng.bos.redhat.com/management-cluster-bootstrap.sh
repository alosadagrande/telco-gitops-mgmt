#!/bin/bash

oc whoami --show-server
oc label node -l kubernetes.io/os=linux ran.openshift.io/lso=''

oc apply -k .

oc patch storageclass lso-filesystemclass \
-p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

oc create secret generic assisted-deployment-pull-secret -n assisted-installer \
--from-file=.dockerconfigjson=pull-secret.json --type=kubernetes.io/dockerconfigjson

oc patch provisioning provisioning-configuration --type merge -p '{"spec":{"watchAllNamespaces": true}}'

oc get secret telco-gitops-cluster -o go-template='{{index .data "admin.password"}}' | base64 -d


