import boto3
import json
import base64
import requests
from argparse import ArgumentParser

def get_headers(mwaa_client, mwaa_env_name):
    token = mwaa_client.create_cli_token(Name=mwaa_env_name)
    url = f"https://{token['WebServerHostname']}/aws_mwaa/cli"
    headers = {
        'Authorization' : 'Bearer ' + token['CliToken'],
        'Content-Type': 'text/plain'
    }
    return {"headers": headers, "url": url}

def get_va_without_double_quotes(val):
    if '{' in val:
        return val
    elif isinstance(val, str):
        return val.replace('"', "")
    return val

def set_mwaa_env_var(mwaa_env_name,mwaa_vars_file_path, aws_region):
    boto3_session = boto3.session.Session(region_name=aws_region)
    mwaa_client = boto3_session.client('mwaa',)
    with open("{}".format(mwaa_vars_file_path), "r") as vars_file_path:
        fileconf = vars_file_path.read().replace('\n', '')
    json_dictionary = json.loads(fileconf)
    headers_url = get_headers(mwaa_client=mwaa_client, mwaa_env_name=mwaa_env_name)
    for key in json_dictionary:
        print(key, " ", json_dictionary[key])
        val = f"{key} '{get_va_without_double_quotes(json.dumps(json_dictionary[key]))}'"
        raw_data = f"variables set {val}"
        mwaa_response = requests.post(
            headers_url['url'],
            headers=headers_url['headers'],
            data=raw_data
        )
        if mwaa_response.status_code == 403:
            # token has probably expired, get a new one
            headers_url = get_headers(mwaa_client=mwaa_client, mwaa_env_name=mwaa_env_name)
            # retry the request
            mwaa_response = requests.post(
                headers_url['url'],
                headers=headers_url['headers'],
                data=raw_data
            )

        try:
            mwaa_std_err_message = base64.b64decode(mwaa_response.json()['stderr']).decode('utf8')
        except requests.JSONDecodeError as err:
            print(err)
            print(mwaa_response.text)
            mwaa_std_err_message = mwaa_response.text
        
        try:
            mwaa_std_out_message = base64.b64decode(mwaa_response.json()['stdout']).decode('utf8')
        except requests.JSONDecodeError as err:
            print(err)
            print(mwaa_response.text)
            mwaa_std_out_message = mwaa_response.text
        print(mwaa_response.status_code)
        print(mwaa_std_err_message)
        print(mwaa_std_out_message)

if __name__ == "__main__":
    parser = ArgumentParser(
        prog="get_mwaa_vars",
        description="Create MWAA variables",
        epilog="Contact Abdelhak Marouane for extra help",
    )
    parser.add_argument("--mwaa_env_name", dest="mwaa_env_name", help="MWAA environement name")

    parser.add_argument("--file_path", dest="file_path", help="path to file")
    parser.add_argument("--aws_region", dest="aws_region", help="AWS region", default="us-west-2")
    args = parser.parse_args()
    if args.file_path:
        set_mwaa_env_var(mwaa_env_name=args.mwaa_env_name, mwaa_vars_file_path=args.file_path, aws_region=args.aws_region)
