terraform {
  required_version = ">=1.9.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.116.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "~> 2.51.0"
    }
  }
}
