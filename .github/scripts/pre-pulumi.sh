#!/bin/bash

# This script is used to 


set -ex

clientId=$1
clientSecret=$2
tenantId=$3
subscriptionId=$4

# 1. Create virtual environment and install dependencies for pulumi command.
python3 -m venv venv/ 
source venv/bin/activate
poetry export --without-hashes -f requirements.txt --output requirements.txt
pip install -r requirements.txt

# 2. Configure the service principle for pulumi command.
./pulumi_wrapper.sh config set azure-native:clientId "$clientId"
./pulumi_wrapper.sh config set azure-native:clientSecret "$clientSecret"
./pulumi_wrapper.sh config set azure-native:tenantId "$tenantId"
./pulumi_wrapper.sh config set azure-native:subscriptionId "$subscriptionId"
