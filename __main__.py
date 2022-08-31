# Copyright 2016-2020, Pulumi Corporation.  All rights reserved.

import pulumi
import pulumi_azure_native.authorization as authorization
import pulumi_azure_native.storage as storage
import pulumi_azure_native.synapse as synapse
import pulumi_azure_native.resources as resources
from pulumi_azure_native import containerregistry
import pulumi_random as random

config = pulumi.Config()

resource_group_name=config.get("resource_group_name")

# storage_account = storage.StorageAccount(
#     "synapsesa",
#     resource_group_name=resource_group_name,
#     sku=storage.SkuArgs(
#         name=storage.SkuName.STANDARD_ZRS,
#     ),
#     kind=storage.Kind.STORAGE_V2
# )

acr = containerregistry.Registry(
    "integrationacr",
    admin_user_enabled=True,
    resource_group_name=resource_group_name,
    sku=containerregistry.SkuArgs(name=containerregistry.SkuName.STANDARD),
    opts=None)
