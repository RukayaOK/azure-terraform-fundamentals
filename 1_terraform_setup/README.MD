# Terraform Setup 

## Contents 
  - [Prerequisites](#prerequisites)
  - [Terraform Setup](#terraform-setup-1)
  - [Automation](#automation)

---
## Prerequisites 
1. Install Terraform 
2. Install Azure CLI 
3. Install jq (optional)


---
## Terraform Setup 

**Under this step we will:**
- Create a service principal in Azure. This is an identity used to create Azure resources. 
- Create a storage account container. This will store your Terraform State file (a database of your resources that exist in your environment)

**Implementation:**
1. Set your Subscription ID as an Environment Variable
You will have an azure subscription ID

    ```sh
    export ARM_SUBSCRIPTION_ID="60f16e2f-9f1c-8f48-d36ca65d0699"
    ```

2. Login to Azure 

    ```sh
    az login 

    az account set -s "${ARM_SUBSCRIPTION_ID}"
    ```

3. Run the below command to create a storage account

    ```bash
    SERVICE_PRINCIPAL_NAME=my-service-principal

    az ad app list \
        --display-name "${SERVICE_PRINCIPAL_NAME}" \
        --query '[].appId' \
        -o tsv
    ```

    Example output:
    ```json
    {
        "appId": "0066b-b5d5-4595-89b0-8b31696098",
        "displayName": "my-terraform-sp",
        "password": "H9Q~6GA0uT~A65L-cLGsEFP5XCuCtXiQlbPG",
        "tenant": "66e3c592-4e7c-4a3y-1562jf3e08lt"
    }
    ```

4. Set the following environment variables

    ```bash
    export ARM_TENANT_ID="66e3c592-4e7c-4a3y-1562jf3e08lt"
    export ARM_CLIENT_ID="0066b-b5d5-4595-89b0-8b31696098"
    export ARM_CLIENT_SECRET="H9Q~6GA0uT~A65L-cLGsEFP5XCuCtXiQlbPG"
    ```

5. Give your Service Principal permissions over your subscription 

    (a) Get the Service Principal Object ID 

    ```bash
    SERVICE_PRINCIPAL_NAME="my-service-principal"

    az ad sp list \
        --display-name $SERVICE_PRINCIPAL_NAME \
        --query "[0].objectId" \
        --output tsv \
        --only-show-errors
    ```

    > The ID returned is the Service Principal Object ID used in the below steps 

    (b) Assigning RBAC Permissions 

    In Azure you can assign the Service Principal roles over specific scopes. The below example gives the Service Principal the "Contributor" role over the "Subscription" scope.

    ```bash
    ROLE="Owner"

    az role assignment create \
        --assignee "${ARM_CLIENT_ID}" \
        --role "${ROLE}" \
        --subscription "${ARM_SUBSCRIPTION_ID}" \
        --only-show-errors 
    ```

    (c) Assign API Permissions

    In Azure you can assign a Service Principal API Permissions allowing it to access 3rd party resources. The below example gives the Service Principal permissions to Read and Write All Directories (i.e. Read and Write Azure AD users and groups)

    ```bash
    SERVICE_PRINCIPAL_OBJECT_ID="462deaec-2d35-4691d-be38-a61eef7rmb6d"
    PERMISSION_NAME=Directory.ReadWrite.All

    GRAPH_API_PERMISSION_ID=$(az ad sp list \
        --query "[?appDisplayName=='Microsoft Graph'].{appId:appId}[0]" \
        --all --only-show-errors | jq -r .appId)

    API_PERMISSION=$(az ad sp show \
        --id "${GRAPH_API_PERMISSION_ID}" \
        --query "appRoles[?value=='${PERMISSION_NAME}'].id" \
        --output tsv \
        --only-show-errors)
    
    az ad app permission add \
        --id "${SERVICE_PRINCIPAL_OBJECT_ID}" \
        --api "${GRAPH_API_PERMISSION_ID}" \
        --api-permissions "${API_PERMISSION}"=Role \
        --only-show-errors

    az ad app permission admin-consent \
        --id "${SERVICE_PRINCIPAL_OBJECT_ID}" \
        --only-show-errors
    ``` 
    > Note: You may have to run this admin-consent command several times. The permissions can take up to 30 minutes to take affect. 

    (d) Assign Azure AD Roles 

    In Azure, you can also assign Service Principals Active Directory Roles. In the below example we assign the Service Principal the "Application Administrator" Azure AD Roles

    ```bash
    SERVICE_PRINCIPAL_OBJECT_ID="462deaec-2d35-4691d-be38-a61eef7rmb6d"

    AZUREAD_ROLE_NAME="Application Administrator"

    MICOSOFT_GRAPH_ENDPOINT=$(az cloud show | jq -r ".endpoints.microsoftGraphResourceId")

    ROLE_AAD=$(az rest --method Get \
                    --uri ${MICOSOFT_GRAPH_ENDPOINT}v1.0/directoryRoles -o json \
                    | jq -r '.value[] | select(.displayName == "'"$(echo ${AZUREAD_ROLE_NAME})"'") | .id')
    
    URI=$(echo "${MICOSOFT_GRAPH_ENDPOINT}v1.0/directoryRoles/${ROLE_AAD}/members/\$ref")

    JSON=$( jq -n \
            --arg uri_role "${MICOSOFT_GRAPH_ENDPOINT}v1.0/directoryObjects/${SERVICE_PRINCIPAL_OBJECT_ID}" \
            '{"@odata.id": $uri_role}' )


    az rest --method POST --uri ${URI} --header Content-Type=application/json --body "${JSON}"


    ```


6. Create a Resource Group 
    ```bash
    RESOURCE_GROUP_NAME=my-terrraform-rg
    RESOURCE_LOCATION=uksouth

    az group create \
        --name "${RESOURCE_GROUP_NAME}" \
        --location "${RESOURCE_LOCATION}"
    ```

7. Create a storage account 
    ```bash
    RESOURCE_GROUP_NAME=my-terrraform-rg
    RESOURCE_LOCATION=uksouth
    STORAGE_ACCOUNT_NAME=mystorageaccount

    az storage account create \
        --name "${STORAGE_ACCOUNT_NAME}" \
        --resource-group "${RESOURCE_GROUP_NAME}" \
        --location "${RESOURCE_LOCATION}" \
        --sku "Standard_LRS" \
        --encryption-services "blob" \
        --kind "StorageV2"
    ```

    To see more options on creating a storage account: https://learn.microsoft.com/en-us/cli/azure/storage/account?view=azure-cli-latest#az-storage-account-create

8. Retrieve Storage Account Keys
    ```bash
    RESOURCE_GROUP_NAME=my-terrraform-rg
    STORAGE_ACCOUNT_NAME=mystorageaccount

    az storage account keys list \
        --resource-group "${RESOURCE_GROUP_NAME}" \
        --account-name "${STORAGE_ACCOUNT_NAME}" \
        --query '[0].value' \
        -o tsv
    ```

9. Create a container 
    ```bash
    STORAGE_ACCOUNT_NAME=mystorageaccount
    STORAGE_CONTAINER_NAME=mycontainer

    az storage container create \
        --name "${STORAGE_CONTAINER_NAME}" \
        --public-access off \
        --account-name "${STORAGE_ACCOUNT_NAME}" 
    ```

10. Get the Access Key for your storage account  
    ```bash
    RESOURCE_GROUP_NAME=my-terrraform-rg
    STORAGE_ACCOUNT_NAME=mystorageaccount

    az storage account keys list \
        --resource-group "${RESOURCE_GROUP_NAME}" \
        --account-name "${STORAGE_ACCOUNT_NAME}" \
        --query '[0].value' -o tsv
    ```

11. Set the following environment variable

    The storage account key should be set below

    ```bash
    export ARM_ACCESS_KEY="66e3c592-2e3c-4a3c-bd56-1412ef3f08ta"
    ```

You are now ready to start terraforming.

---
## Automation
