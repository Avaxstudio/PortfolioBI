#Required provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
  }
  required_version = ">= 1.3"
}

#Microsoft Azure Provider
provider "azurerm" {
  features {}
}

#Exported Environment Variables
# export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
# export ARM_CLIENT_SECRET="12345678-0000-0000-0000-000000000000"
# export ARM_TENANT_ID="10000000-0000-0000-0000-000000000000"
# export ARM_SUBSCRIPTION_ID="20000000-0000-0000-0000-000000000000"

