import boto3
import os
import logging


def update_mwaa(version_id):
    client = boto3.client('mwaa')
    env_name = os.environ.get('MWAA_ENV_NAME')
    response = client.update_environment(Name=env_name, RequirementsS3ObjectVersion=version_id)
    return response


def handler(event, context):
    record = event['Records'][0]
    s3_object = record['s3']['object']
    if 'requirements.txt' not in s3_object['key']:
        logging.info("This is not requirements.tx")
    version_id = s3_object['versionId']
    return update_mwaa(version_id)
