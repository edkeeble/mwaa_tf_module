# Amazon MWAA

## Description 
Secure and highly available managed workflow orchestration for Apache Airflow.
[source](https://aws.amazon.com/managed-workflows-for-apache-airflow)

## Requirements
- Terrraform (v1.3.1 or higher)  [install terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- AWS Account


## How to deploy
```bash

$cp .env.example .env
$bash deploy.sh
```

## Example start a dag with boto3
```python
import requests
import boto3
client = boto3.client('mwaa')
token = client.create_cli_token(Name='<env_name>')
url = f"https://{token['WebServerHostname']}/aws_mwaa/cli"
headers = {
'Authorization' : 'Bearer ' + token['CliToken'],
 'Content-Type': 'text/plain'
}
body = 'dags trigger <dag_id>'
requests.post(url, data=body, headers=headers)

```