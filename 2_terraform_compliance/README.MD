# Terraform Compliance 

Many times, compliance testing is part of the continuous integration process and is used to ensure that user-defined policies are followed. For example, you might define geopolitical naming conventions for your Azure resources.

https://learn.microsoft.com/en-gb/azure/developer/terraform/best-practices-compliance-testing

Install
pip install terraform-compliance


Plan
terraform plan -var-file config.tfvars -out plan/main.tfplan
terraform show -json plan/main.tfplan > plan/main.tfplan.json

Test Compliance
terraform-compliance -f features -p plan/main.tfplan.json


Output
```bash
terraform-compliance v1.3.33 initiated

🚩 Features     : /Users/rukayaok/Documents/azure/9_terraform_compliance/features/
🚩 Plan File    : /Users/rukayaok/Documents/azure/9_terraform_compliance/plan/main.tfplan.json

🚩 Running tests. 🎉

Feature: Test tagging compliance  # /Users/rukayaok/Documents/azure/9_terraform_compliance/features/tagging.feature

    Scenario: Ensure all resources have tags
        Given I have resource that supports tags defined
        Then it must contain tags
                Failure: tags property in azurerm_resource_group.main is considered to be Null. It is set to "{}".
        And its value must not be null
          Failure: 

    Scenario Outline: Ensure that specific tags are defined
        Given I have resource that supports tags defined
        When it has tags
        Then it must contain <tags>
        And its value must match the "<value>" regex

    Examples:
        | tags        | value            |
        💡 SKIPPING: Can not find any tags property for resource that supports tags resource in terraform plan.
        💡 SKIPPING: Skipping the step since resource type does not have tags property.
        | Creator     | .+               |
        💡 SKIPPING: Can not find any tags property for resource that supports tags resource in terraform plan.
        💡 SKIPPING: Skipping the step since resource type does not have tags property.
        | Application | .+               |
        💡 SKIPPING: Can not find any tags property for resource that supports tags resource in terraform plan.
        💡 SKIPPING: Skipping the step since resource type does not have tags property.
        | Role        | .+               |
        💡 SKIPPING: Can not find any tags property for resource that supports tags resource in terraform plan.
        💡 SKIPPING: Skipping the step since resource type does not have tags property.
        | Environment | ^(prod|uat|dev)$ |

1 features (0 passed, 1 failed)
5 scenarios (0 passed, 1 failed, 4 skipped)
19 steps (6 passed, 1 failed, 4 skipped)
Run 1664619973 finished within a moment
```


Feature: Test tagging compliance

Scenario: Ensure all resources have tags
    Given I have resource that supports tags defined
    Then it must contain tags
    And its value must not be null

Scenario Outline: Ensure that specific tags are defined
    Given I have resource that supports tags defined
    When it has tags
    Then it must contain <tags>
    And its value must match the "<value>" regex

    Examples:
      | tags        | value              |
      | Creator     | .+                 |
      | Application | .+                 |
      | Role        | .+                 |
      | Environment | ^(prod\|uat\|dev)$ |


https://github.com/libre-devops/azure-naming-convention