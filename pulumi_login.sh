#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
DEV_ENV_FILE="$SCRIPT_DIR/.pulumi-dev.env"


# Remove the old file so that things don't run if this script errors partially
if [ -f "$DEV_ENV_FILE" ]; then
  rm "$DEV_ENV_FILE"
fi

# Storage account used in dev
export AZURE_STORAGE_ACCOUNT=axpulumistorage


export AZURE_STORAGE_ACCOUNT_RG="ax-learning"


# TODO - see if the service principal login details can be used instead
# Set later
export AZURE_STORAGE_KEY=""

# Pulumi project to simplify other tasks
AIA_PROJECT_NAME=""

# Defaulting the storage key
# This will be replaced with a proper a value from a key store later / dev
PULUMI_CONFIG_PASSPHRASE="${AZURE_STORAGE_ACCOUNT:0:8}"


function usage() {
  echo "Usage:"
  echo "$0 -p <project-name>"
  echo ""
  echo "-p | --project   Specify the project name (datasci | runtime | datalanding)"
  echo "-h | --help      Print this help "
}


while [[ $# -gt 0 ]]; do
  case $1 in
    -p|--project)
      AIA_PROJECT_NAME="$2"
      shift # past argument
      shift # past value
      ;;
#    -s|--storage)
#      AZURE_STORAGE_ACCOUNT="$2"
#      shift # past argument
#      shift # past value
#      ;;
#    -k|--config-key)
#      PULUMI_CONFIG_PASSPHRASE="$2"
#      shift # past argument
#      shift # past value
#      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option $1"
      usage
      exit 1
      ;;
    *)
  esac
done


if [ -z "$AIA_PROJECT_NAME" ]; then
  echo 'Missing `project-name` setting'
  usage
  exit 1
fi

AZURE_STORAGE_KEY="$(az storage account keys list --account-name "$AZURE_STORAGE_ACCOUNT" --resource-group "$AZURE_STORAGE_ACCOUNT_RG" --output json --query "[0].value" --output tsv)"

cat > "$DEV_ENV_FILE" << EOF
#!/usr/bin/env bash

set -e

# This script is auto generated from pulumi_dev_login.sh
export AZURE_STORAGE_ACCOUNT='$AZURE_STORAGE_ACCOUNT'
export AZURE_STORAGE_KEY='$AZURE_STORAGE_KEY'
AIA_PROJECT_NAME='$AIA_PROJECT_NAME'
export PULUMI_CONFIG_PASSPHRASE='$PULUMI_CONFIG_PASSPHRASE'
export AZURE_STORAGE_ACCOUNT_RG="ax-learning"
export AZURE_KEYVAULT_AUTH_VIA_CLI="true"
export MERATIVE_PROJECT_KEYVAULT="axpulumikv"
EOF

pulumi login "azblob://${AIA_PROJECT_NAME//[_]/-}"