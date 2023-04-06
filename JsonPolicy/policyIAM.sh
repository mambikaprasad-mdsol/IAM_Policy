#!/bin/bash


#https://github.com/mambikaprasad-mdsol/IAM_Policy/tree/devops_IAMpolicy_-IH-455195
ROLE_NAME="DemoIAM_AWS2_sandbox-"
stage_region="us-east-1"
stage_environment="sandbox"

content=$(jq .Policy[0].Statement[0].Action[0] ./resourcePolicy.json)
echo $content
aws iam get-role --role-name $ROLE_NAME --output text --profile aws-green
if [ $? -eq 0 ]; then
  echo "Role exists"
  length=$(jq '.Policy | length' ./resourcePolicy.json)
  for (( c=0; c<$length; c++ ))
  do 
        content=$(jq .Policy[$c] ./resourcePolicy.json)
        echo $c
        aws iam put-role-policy --role-name $ROLE_NAME --policy-name Policy_$c --policy-document "$content" --output text --profile aws-green
        
  done
  export ROLE_NAME=$1
else
  echo "Role does not exist"
  aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document file://Policy.json --output text --profile aws-green
  length=$(jq '.Policy | length' ./resourcePolicy.json)
  for (( c=0; c<$length; c++ ))
  do 
        content=$(jq .Policy[$c] ./resourcePolicy.json)
        echo $c
        aws iam put-role-policy --role-name $ROLE_NAME --policy-name Policy_$c --policy-document "$content" --output text --profile aws-green
        
  done
fi





