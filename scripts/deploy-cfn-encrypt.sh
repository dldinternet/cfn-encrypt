#!/usr/bin/env bash

STACK_NAME=${STACK_NAME:-Rotech-Cfn-Encrypt}
TEMPLATE_NAME=${TEMPLATE_NAME:-cfn-encrypt-template.yaml}

if test -f $TEMPLATE_NAME ; then

  aws s3 cp $TEMPLATE_NAME s3://$BUCKET_NAME/
  aws cloudformation describe-stacks --stack-name $STACK_NAME
  RC=$?
  if test 0 -eq $RC ; then
    aws cloudformation update-stack --region us-east-1 --template-url https://$BUCKET_NAME.s3.amazonaws.com/$TEMPLATE_NAME  \
      --stack-name $STACK_NAME --parameters "ParameterKey=KmsKeyArn,ParameterValue=$KMS_KEY_ARN" \
     --capabilities CAPABILITY_IAM
  else
    aws cloudformation create-stack --region us-east-1 --template-url https://$BUCKET_NAME.s3.amazonaws.com/$TEMPLATE_NAME  \
      --disable-rollback --enable-termination-protection \
      --stack-name $STACK_NAME --parameters "ParameterKey=KmsKeyArn,ParameterValue=$KMS_KEY_ARN" \
     --capabilities CAPABILITY_IAM
  fi
  RC=$?
  if test 0 -eq $RC ; then
    i=0
    while test $i -lt 10 ; do
      aws cloudformation describe-stack-events --stack-name $STACK_NAME --max-items=1
      RC=$?
      sleep 5
      i=$((i+1))
    done
  fi

#  echo aws cloudformation deploy --region us-east-1 --template cfn-encrypt-template.yaml --s3-bucket $BUCKET_NAME \
#   --stack-name $STACK_NAME --parameter-overrides KmsKeyArn=$KMS_KEY_ARN \
#   --capabilities CAPABILITY_IAM
else
  echo ERROR: Missing $TEMPLATE_NAME
  exit 1
fi
