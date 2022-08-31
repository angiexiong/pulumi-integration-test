#!/usr/bin/env bash

#
# Adds permissions for the current user to be able to utilize Key Vault
#

set -e

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
if [ -f "$SCRIPT_DIR/.pulumi-dev.env" ]; then
  # Use env settings
  . "$SCRIPT_DIR/.pulumi-dev.env"
else
  echo "ERROR: missing - '.pulumi-dev.env'"
  echo "  Please run 'pulumi_login.sh' first"
  exit 1
fi

echo "Current pulumi project: $AIA_PROJECT_NAME"

# CD to project
cd "$SCRIPT_DIR"
CURRENT_USER_NAME="$(az account show --query user.name -o tsv)"
CURRENT_USER_ID="$(az ad user show --id "7a78efae-1e46-4f5d-98e1-1e0cadbc70b1" --query id --out tsv)"

# Set the relevant permissions on the keyvault
az keyvault set-policy --key-permissions decrypt get create delete list update encrypt \
  --name "$MERATIVE_PROJECT_KEYVAULT" --object-id "$CURRENT_USER_ID" --resource-group "$AZURE_STORAGE_ACCOUNT_RG"
