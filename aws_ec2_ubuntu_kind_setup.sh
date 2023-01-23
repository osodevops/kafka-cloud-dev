#!/bin/bash
# source this file to export ENVs: source aws_ec2_ubuntu_kind_setup.sh

# before anything you do: mkdir $HOME/.kube/clusters
# this is due to keeping configs in isolation
# remove previous config
rm -f -- $HOME/.kube/clusters/config

# get instance id
export REMOTE_IP=$(aws ec2 describe-instances \
--filters "Name=tag:Name,Values=kind" \
--query "Reservations[*].Instances[*].[PublicIpAddress]" \
--output text)

# copy kubeconfig of remote cluster to your disk
ssh ubuntu@$REMOTE_IP kind get kubeconfig > $HOME/.kube/clusters/config

# export and edit config
export KUBECONFIG=$HOME/.kube/clusters/config
sed -i '' -e "s/0.0.0.0/$REMOTE_IP/" $KUBECONFIG
sed -i '' -e "5s/^//p; 5s/^.*/    tls-server-name: kind-control-plane/" $KUBECONFIG
echo $KUBECONFIG