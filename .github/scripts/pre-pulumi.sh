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
./pulumi_login.sh -p datasci
./pulumi_wrapper.sh stack select ax-dev
export clientId="$ARM_CLIENT_ID"
export clientSecret="$ARM_CLIENT_SECRET"
export tenantId="$ARM_TENANT_ID"
export subscriptionId="$ARM_SUBSCRIPTION_ID"
# ./pulumi_wrapper.sh config set azure-native:clientId "$ARM_CLIENT_ID"
# ./pulumi_wrapper.sh config set azure-native:clientSecret "$ARM_CLIENT_SECRET" --secret
# ./pulumi_wrapper.sh config set azure-native:tenantId "$ARM_TENANT_ID"
# ./pulumi_wrapper.sh config set azure-native:subscriptionId "$ARM_SUBSCRIPTION_ID"
