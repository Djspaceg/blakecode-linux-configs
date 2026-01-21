#!/bin/bash -e

### AWS CloudFormation Pipeline Resource Cleaner ###
#
# CDK tends to leave a lot of traces in various AWS resources when creating pipelines 
# via CloudFormation, and it doesn't do a proper cleanup upon failures.
#
# This script tries to gather the resources created by CDK and completely nuke them in a proper order.
#
# NOTE !!!
# This script is created with limited thoughts and is only applicable to AWS accounts for CDK pipelines.
# 
# AWS CLI setup: https://w.amazon.com/bin/view/Infosec/Private/SecInt/Operational/AwsCli/
#
# Author: ruifenm@
# Date: 2021-Apr-26

export AWS_PROFILE="myijanus-view-losg-beta-na"

remove_quotes () {
  temp="${1%\"}"
  temp="${temp#\"}"
  echo "${temp}"
}

####### IAM Roles and Policies - start #######
echo "[1]>>>>> Removing IAM roles and policies ..."
roles=$(aws --profile ${AWS_PROFILE} iam list-roles | jq '.Roles[].RoleName' | grep Pipeline | grep CloudForm || true)

for r in "${roles[@]}"
do
  role_name=$(remove_quotes "${r}")

  policies=$(aws --profile ${AWS_PROFILE} iam list-role-policies --role-name "${role_name}" | jq '.PolicyNames[]')

  for p in "${policies[@]}"
  do
    echo "Removing role policy ${p} ..."
    policy_name=$(remove_quotes "${p}")
    aws --profile ${AWS_PROFILE} iam delete-role-policy --role-name "${role_name}" --policy-name "${policy_name}" > /dev/null
  done

  echo "Removing role ${r} ..."
  aws --profile ${AWS_PROFILE} iam delete-role --role-name "${role_name}" > /dev/null
done

echo -e "[1]<<<<< IAM roles and policies removal completed."
####### IAM Roles and Policies - end #######

####### Cloudwatch Log Groups - start #######
printf "\n[2]>>>>> Removing Cloudwatch log groups ...\n"
log_groups=$(aws --profile ${AWS_PROFILE} logs describe-log-groups | jq '.logGroups[].logGroupName' || true)

for l in "${log_groups[@]}"
do
  group_name=$(remove_quotes "${l}")
  echo "Removing log group ${l} ..."
  aws --profile ${AWS_PROFILE} logs delete-log-group --log-group-name "${group_name}" > /dev/null
done

echo "[2]<<<<< Cloudwatch log groups removal completed."
####### Cloudwatch Log Groups - end #######

####### Elastic Container Registries - start #######
printf "\n[3]>>>>> Removing elastic container registries ...\n"
ecr_repos=$(aws --profile ${AWS_PROFILE} ecr describe-repositories | jq '.repositories[].repositoryName' || true)

for r in "${ecr_repos[@]}"
do
  repo_name=$(remove_quotes "${r}")
  echo "Removing ECR repository ${r} ..."
  aws --profile ${AWS_PROFILE} ecr delete-repository --repository-name "${repo_name}" > /dev/null
done

echo "[3]<<<<< Elastic container registries removal completed."
####### Cloudwatch Log Groups - end #######

####### S3 Buckets - start #######
printf "\n[4]>>>>> Removing S3 buckets ...\n"
s3_buckets=$(aws --profile ${AWS_PROFILE} s3 ls | awk '{print $3;}' | grep deploy || true)

for b in "${s3_buckets[@]}"
do
  bucket_name=$(remove_quotes "${b}")
  echo "Removing S3 bucket ${b} ..."
  aws --profile ${AWS_PROFILE} s3 rb s3://"${bucket_name}" --force > /dev/null
done

echo "[4]<<<<< S3 buckets removal completed."
####### S3 Buckets - end #######

####### Cloud formation stacks - start #######
printf "\n[5]>>>>> Removing CloudFormation stacks ...\n"
cf_stacks=$(aws --profile ${AWS_PROFILE} cloudformation list-stacks | jq '.StackSummaries[] | select(.StackStatus !="DELETE_COMPLETE") | .StackName' | grep Pipeline || true)

for s in "${cf_stacks[@]}"
do
  stack_name=$(remove_quotes "${s}")
  echo "Terminating protection on CloudFormation stack ${s} ..."
  aws --profile ${AWS_PROFILE} cloudformation update-termination-protection --no-enable-termination-protection --stack-name "${stack_name}" > /dev/null
  echo "Removing CloudFormation stack ${s} ..."
  aws --profile ${AWS_PROFILE} cloudformation delete-stack --stack-name "${stack_name}" > /dev/null
done

####### Cloud formation stacks - start #######
printf "\n[5]>>>>> Removing CloudFormation stacks ...\n"

pipeline_stacks=$(aws --profile ${AWS_PROFILE} cloudformation list-stacks | jq '.StackSummaries[] | select(.StackStatus !="DELETE_COMPLETE") | .StackName' | grep Pipeline || true)
echo "Pipeline stacks in us-east-1 region: "
for s in "${pipeline_stacks[@]}"
do
  stack_name=$(remove_quotes "${s}")
  echo "Terminating protection on CloudFormation stack ${s} ..."
  aws --profile ${AWS_PROFILE} cloudformation update-termination-protection --no-enable-termination-protection --stack-name "${stack_name}" > /dev/null
  echo "Removing CloudFormation stack ${s} ..."
  aws --profile ${AWS_PROFILE} cloudformation delete-stack --stack-name "${stack_name}" > /dev/null
done

bootstrap_stacks=$(aws --profile ${AWS_PROFILE} --region us-west-2 cloudformation list-stacks | jq '.StackSummaries[] | select(.StackStatus !="DELETE_COMPLETE") | .StackName' | grep Bootstrap || true)
echo "Bootstrap stacks in us-west-2 region: "
for p in "${bootstrap_stacks[@]}"
do
  stack_name=$(remove_quotes "${p}")
  echo "Terminating protection on CloudFormation stack ${p} ..."
  aws --profile ${AWS_PROFILE} --region us-west-2 cloudformation update-termination-protection --no-enable-termination-protection --stack-name "${stack_name}" > /dev/null
  echo "Removing CloudFormation stack ${p} ..."
  aws --profile ${AWS_PROFILE} --region us-west-2 cloudformation delete-stack --stack-name "${stack_name}" > /dev/null
done

echo "[5]<<<<< CloudFormation stacks removal completed."
####### Cloud formation stacks - end #######
