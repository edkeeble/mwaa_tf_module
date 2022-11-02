#! /bin/bash
# Check .env file
if [ -f .env ]
then
  set -a; source .env; set +a
else
  echo "Please create .env file first"
  exit 1
fi


function generate_terraform_variables {
  tf_vars=(tf tfvars)
    for tf_var in "${tf_vars[@]}"; do
    (
      echo "cat <<EOF"
      cat terraform.${tf_var}.tmpl
      echo EOF
    ) | sh > terraform.${tf_var}
  done

}

function check_create_remote_state {
  # $1 aws_region
  # $2 bucket name
  # $3 dynamotable_name
  # $4 aws profile
  AWS_REGION=$1
  STATE_BUCKET_NAME=$2
  STATE_DYNAMO_TABLE=$3
  AWS_PROFILE=$4
  
  bucketstatus=$(aws s3api head-bucket --bucket $STATE_BUCKET_NAME --profile $AWS_PROFILE 2>&1)
  if echo "${bucketstatus}" | grep 'Not Found';
then
      echo "Creating TF remote state"
      source create_state_bucket.sh
      create_state_bucket $AWS_REGION $STATE_BUCKET_NAME $AWS_PROFILE
      create_dynamo_db $AWS_REGION $STATE_DYNAMO_TABLE $AWS_PROFILE
elif echo "${bucketstatus}" | grep 'Forbidden';
then
  echo "Bucket $STATE_BUCKET_NAME exists but not owned"
  exit 1
elif echo "${bucketstatus}" | grep 'Bad Request';
then
  echo "Bucket $STATE_BUCKET_NAME specified is less than 3 or greater than 63 characters"
  exit 1
else
  echo "State Bucket $STATE_BUCKET_NAME owned and exists. Continue...";
  echo "State Dynamo table $STATE_DYNAMO_TABLE owned and exists. Continue...";
fi

}


generate_terraform_variables
check_create_remote_state $AWS_REGION $STATE_BUCKET_NAME $STATE_DYNAMO_TABLE $AWS_PROFILE

read -rp 'action [init|plan|deploy]: ' ACTION
case $ACTION in
  init)
    terraform init
    ;;
  plan)
    terraform plan
    ;;

  deploy)
    terraform apply --auto-approve
    ;;
  *)
    echo "Chose from 'init', 'plan' or 'deploy'"
    exit 1
    ;;
esac

