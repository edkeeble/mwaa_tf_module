#! /bin/bash

function create_state_bucket {
  # $1 region
  # $2 bucket_name
  # $3 aws_profile

  aws s3 mb  s3://$2  --region $1
  aws s3api put-bucket-versioning \
    --bucket $2 \
    --versioning-configuration Status=Enabled \
    --profile $3
}

function create_dynamo_db {
  # $1 region
  # $2 table_name
  # $3 aws_profile
  aws dynamodb create-table \
    --table-name $2 \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region $1 \
    --profile $3

}