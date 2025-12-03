#!/usr/bin/env bash

kubectl logs -n kube-system -l app.kubernetes.io/name=democratic-csi-iscsi -c driver
kubectl describe pod -n kube-system $1
