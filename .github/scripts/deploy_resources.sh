#!/bin/bash

set -ex

poetry run pulumi login "azblob://$AIA_PROJECT_NAME"
poetry run pulumi stack select "$AIA_PULUMI_STACK_NAME"

if [ "$GITHUB_REF_NAME" == "main" ]; then
  echo "Update the resources on main."
  poetry run pulumi update --yes
else
  echo "Preview the resources in a PR."
  poetry run pulumi preview
fi
