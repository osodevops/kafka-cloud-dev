#!/bin/bash
aws ec2 describe-instances --filters "Name=tag:Name,Values=kind" --query "Reservations[].Instances[].[InstanceId]" --output text|while read line
do
 echo "terminating the instance with id $line"
# append at the end --dry-run
 aws ec2 terminate-instances --instance-ids $line
done