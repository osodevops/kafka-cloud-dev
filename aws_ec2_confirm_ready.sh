#!/bin/bash

REMOTE_IP=$(aws ec2 describe-instances \
--filters "Name=tag:Name,Values=kind" \
--query "Reservations[*].Instances[*].[PublicIpAddress]" \
--output text) && \
ssh ubuntu@$REMOTE_IP kind get clusters