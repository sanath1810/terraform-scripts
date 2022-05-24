// Configure the Microsoft AzureRM Provider
// Site Specific AzureRM Provider
provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  features {}
}

// Specify the version of the AzureRM Provider to use
terraform {
  required_version = ">= 1.0.8"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.1.0"
    }
  }
}


