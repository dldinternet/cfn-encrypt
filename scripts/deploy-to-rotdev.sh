#!/usr/bin/env bash

# To debug uncomment this
set -x
export AWS_PROFILE=rotdev
export AWS_DEFAULT_REGION=us-east-1
export STACK_NAME=Rotech-Cfn-Encrypt
export BUCKET_NAME=rotech-dev-sam-cli-managed-default-samclisourcebucket
export KMS_KEY_ARN='arn:aws:kms:us-east-1:884469849986:key/46a4e895-d263-4fd0-a0cc-f23df0f3855b'

. "$(dirname "$0")/deploy-cfn-encrypt.sh"

