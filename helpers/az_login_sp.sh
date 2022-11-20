#!/bin/bash

echo ------------------------------------------
echo "Logging into Azure with Bootstrap Service Principal: $ARM_CLIENT_ID..."
echo ------------------------------------------
az login --service-principal \
    --username=$ARM_CLIENT_ID \
    --password=$ARM_CLIENT_SECRET \
    --tenant $ARM_TENANT_ID
echo ------------------------------------------
echo "Logged into Azure with Bootstrap Service Principal: $ARM_CLIENT_ID"
echo ------------------------------------------

echo ------------------------------------------
echo "Setting default root Azure Subscription: $ARM_SUBSCRIPTION_ID..."
echo ------------------------------------------
az account set -s $ARM_SUBSCRIPTION_ID
echo ------------------------------------------
echo "Set default root Azure Subscription: $ARM_SUBSCRIPTION_ID"
echo ------------------------------------------