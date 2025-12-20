#!/bin/bash

set -eux
set -o pipefail

if aws ecr describe-repositories --repository-names umami-app\
 --region eu-west-2 >/dev/null 2>&1; then
  echo "ECR repo already exists"
else
  aws ecr create-repository --repository-name umami-app\
   --image-scanning-configuration scanOnPush=true \
    --encryption-configuration encryptionType=AES256\
     --region eu-west-2
fi

aws ecr put-lifecycle-policy --repository-name umami-app\
  --lifecycle-policy-text "file://lifecycle_policy.json"\
   --region eu-west-2 

terraform init
terraform import module.ecr.aws_ecr_repository.repo umami-app