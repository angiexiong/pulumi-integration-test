#!/bin/bash

# This script is used to 


set -ex

# clientId=$1
# clientSecret=$2
# tenantId=$3
# subscriptionId=$4

# 1. Create virtual environment and install dependencies for pulumi command.
python3 -m venv venv/ 
source venv/bin/activate
poetry export --without-hashes -f requirements.txt --output requirements.txt
pip install -r requirements.txt

# 2. Authenticate to Azure using a Service Principal.
# Otherwise the pulumi commands will run in User mode.

# Explicitly export the environment variables. Otherwise it can't log in.
export AZURE_STORAGE_ACCOUNT=$AZURE_STORAGE_ACCOUNT
export AZURE_STORAGE_KEY=$AZURE_STORAGE_KEY
export PULUMI_CONFIG_PASSPHRASE=$PULUMI_CONFIG_PASSPHRASE

pulumi login "azblob://$project_name"
pulumi stack select "$pulumi_stack_name"

pulumi config set azure-native:clientId "$ARM_CLIENT_ID"
pulumi config set azure-native:clientSecret "$ARM_CLIENT_SECRET" --secret
pulumi config set azure-native:tenantId "$ARM_TENANT_ID"
pulumi config set azure-native:subscriptionId "$ARM_SUBSCRIPTION_ID"
