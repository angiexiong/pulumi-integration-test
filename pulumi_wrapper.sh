#!/usr/bin/env bash

#
# Wrapper script to simplify working with pulumi
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
cd "$SCRIPT_DIR/aia_azure_deploy/$AIA_PROJECT_NAME"

# Use poetry to execute
poetry run pulumi "$@"
