terraform {

  required_version = ">=1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }

  backend "azurerm" {

    resource_group_name  = "First-Policy"

    storage_account_name = "stterraformstateamit009"

    container_name       = "tfstate"

    key                  = "enterprise-governance.tfstate"

  }

}

provider "azurerm" {

  features {}

  subscription_id = "6b3de81f-c407-4fc8-b47f-534df4ba62d4"

}

data "azurerm_subscription" "current" {}

#################################################
# Resource Group
#################################################

resource "azurerm_resource_group" "governance" {

  name     = "rg-governance-terraform"
  location = "Central India"

  tags = {
    Environment = "Sandbox"
    Owner       = "Amit"
    CostCenter  = "IT001"
  }

}

#################################################
# POLICY 1 - Allowed Locations
#################################################

resource "azurerm_subscription_policy_assignment" "allowed_locations" {

  name            = "allowed-locations-policy"
  subscription_id = data.azurerm_subscription.current.id

  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = ["centralindia"]
    }
  })

}

#################################################
# POLICY 2 - Require Environment Tag
#################################################

resource "azurerm_subscription_policy_assignment" "require_environment_tag" {

  name            = "require-environment-tag"
  subscription_id = data.azurerm_subscription.current.id

  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"

  parameters = jsonencode({
    tagName = {
      value = "Environment"
    }
  })

}

#################################################
# POLICY 3 - Restrict VM Sizes
#################################################

resource "azurerm_subscription_policy_assignment" "allowed_vm_sizes" {

  name            = "allowed-vm-sizes-policy"
  subscription_id = data.azurerm_subscription.current.id

  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3"

  parameters = jsonencode({
    listOfAllowedSKUs = {
      value = [
        "Standard_B1s",
        "Standard_B2s",
        "Standard_D2s_v3"
      ]
    }
  })

}

#################################################
# POLICY 4 - Storage Network Restriction
#################################################

resource "azurerm_subscription_policy_assignment" "storage_network" {

  name            = "storage-network-security"
  subscription_id = data.azurerm_subscription.current.id

  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/34c877ad-507e-4c82-993e-3452a6e0ad3c"

}