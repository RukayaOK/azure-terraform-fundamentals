# Checkov Scan 

Checkov is a static code analysis tool for scanning infrastructure as code files for misconfigurations.

The rules can be found here: https://docs.bridgecrew.io/docs/azure-policy-index

1. Install Checkov 
    ```
    pip install checkov
    ```
    OR
    ```
    brew install checkov
    ```

2. Scan the Terraform Plan 
    
    (a) Create a folder for the terraform plan 
    ```
    mkdir plan 
    ```

    (b) Create the terraform plan 
    ```
    terraform plan --var-file config.tfvars --out plan/tfplan.binary
    ```
    (c) Convert the plan file to json
    ```
    terraform show -json plan/tfplan.binary > plan/tfplan.json
    ```
    (d) Run Chekov against the plan
    ```
    checkov -f plan/tfplan.json
    ```

    output:
    ```
    [ kubernetes framework ]: 100%|████████████████████|[1/1], Current File Scanned=plan/tfplan.json
    [ bitbucket_configuration framework ]: 100%|████████████████████|[1/1], Current File Scanned=../plan/tfplan.json
    [ gitlab_configuration framework ]: 100%|████████████████████|[1/1], Current File Scanned=../plan/tfplan.json
    [ github_configuration framework ]: 100%|████████████████████|[1/1], Current File Scanned=../plan/tfplan.json
    [ secrets framework ]: 100%|████████████████████|[1/1], Current File Scanned=plan/tfplan.json

          _               _              
      ___| |__   ___  ___| | _______   __
      / __| '_ \ / _ \/ __| |/ / _ \ \ / /
    | (__| | | |  __/ (__|   < (_) \ V / 
      \___|_| |_|\___|\___|_|\_\___/ \_/  
                                          
    By bridgecrew.io | version: 2.1.242 
    ```

3. Run Checkov against all the Terraform files in the directory & sub-directories
    ```
    checkov -d .
    ```

    output:
    ```
    Check: CKV_AZURE_59: "Ensure that Storage accounts disallow public access"
        PASSED for resource: azurerm_storage_account.example
        File: /another-terraform-folder/main.tf:6-13
        Guide: https://docs.bridgecrew.io/docs/ensure-that-storage-accounts-disallow-public-access
    Check: CKV_AZURE_60: "Ensure that storage account enables secure transfer"
            PASSED for resource: azurerm_storage_account.example
            File: /another-terraform-folder/main.tf:6-13
            Guide: https://docs.bridgecrew.io/docs/ensure-that-storage-account-enables-secure-transfer
    Check: CKV_AZURE_36: "Ensure 'Trusted Microsoft Services' is enabled for Storage Account access"
            PASSED for resource: azurerm_storage_account.example
            File: /another-terraform-folder/main.tf:6-13
            Guide: https://docs.bridgecrew.io/docs/enable-trusted-microsoft-services-for-storage-account-access
    Check: CKV_AZURE_3: "Ensure that 'Secure transfer required' is set to 'Enabled'"
            PASSED for resource: azurerm_storage_account.example
            File: /another-terraform-folder/main.tf:6-13
            Guide: https://docs.bridgecrew.io/docs/ensure-azure-secure-transfer-required-feature-is-set-to-enabled
    Check: CKV_AZURE_33: "Ensure Storage logging is enabled for Queue service for read, write and delete requests"
            FAILED for resource: azurerm_storage_account.example
            File: /another-terraform-folder/main.tf:6-13
            Guide: https://docs.bridgecrew.io/docs/enable-requests-on-storage-logging-for-queue-service

                    6  | resource "azurerm_storage_account" "example" {
                    7  |   name                     = "${lower(var.storage_account_name)}${random_string.random.result}"
                    8  |   resource_group_name      = var.resource_group_name
                    9  |   location                 = var.location
                    10 |   account_tier             = "Standard"
                    11 |   account_replication_type = "GRS"
                    12 |  
                    13 | }

    Check: CKV_AZURE_35: "Ensure default network access rule for Storage Accounts is set to deny"
            FAILED for resource: azurerm_storage_account.example
            File: /another-terraform-folder/main.tf:6-13
            Guide: https://docs.bridgecrew.io/docs/set-default-network-access-rule-for-storage-accounts-to-deny

                    6  | resource "azurerm_storage_account" "example" {
                    7  |   name                     = "${lower(var.storage_account_name)}${random_string.random.result}"
                    8  |   resource_group_name      = var.resource_group_name
                    9  |   location                 = var.location
                    10 |   account_tier             = "Standard"
                    11 |   account_replication_type = "GRS"
                    12 |  
                    13 | }

    Check: CKV_AZURE_44: "Ensure Storage Account is using the latest version of TLS encryption"
            FAILED for resource: azurerm_storage_account.example
            File: /another-terraform-folder/main.tf:6-13
            Guide: https://docs.bridgecrew.io/docs/bc_azr_storage_2

                    6  | resource "azurerm_storage_account" "example" {
                    7  |   name                     = "${lower(var.storage_account_name)}${random_string.random.result}"
                    8  |   resource_group_name      = var.resource_group_name
                    9  |   location                 = var.location
                    10 |   account_tier             = "Standard"
                    11 |   account_replication_type = "GRS"
                    12 |  
                    13 | }

    Check: CKV2_AZURE_1: "Ensure storage for critical data are encrypted with Customer Managed Key"
            FAILED for resource: azurerm_storage_account.example
            File: /another-terraform-folder/main.tf:6-13
            Guide: https://docs.bridgecrew.io/docs/ensure-storage-for-critical-data-are-encrypted-with-customer-managed-key

                    6  | resource "azurerm_storage_account" "example" {
                    7  |   name                     = "${lower(var.storage_account_name)}${random_string.random.result}"
                    8  |   resource_group_name      = var.resource_group_name
                    9  |   location                 = var.location
                    10 |   account_tier             = "Standard"
                    11 |   account_replication_type = "GRS"
                    12 |  
                    13 | }

    Check: CKV2_AZURE_18: "Ensure that Storage Accounts use customer-managed key for encryption"
            FAILED for resource: azurerm_storage_account.example
            File: /another-terraform-folder/main.tf:6-13
            Guide: https://docs.bridgecrew.io/docs/ensure-that-storage-accounts-use-customer-managed-key-for-encryption

                    6  | resource "azurerm_storage_account" "example" {
                    7  |   name                     = "${lower(var.storage_account_name)}${random_string.random.result}"
                    8  |   resource_group_name      = var.resource_group_name
                    9  |   location                 = var.location
                    10 |   account_tier             = "Standard"
                    11 |   account_replication_type = "GRS"
                    12 |  
                    13 | }


    ```

4. In pre-commit

https://www.torivar.com/2022/06/16/secure-your-terraform-iac-with-checkov/


5. In CI/CD

https://www.torivar.com/2022/06/16/secure-your-terraform-iac-with-checkov/