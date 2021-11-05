terraform {
  required_providers {
    azurerm =  "~> 2.33"
    random = "~> 2.2"
    databricks = {
      source = "databrickslabs/databricks"
      version = "0.3.10"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "databricks" {
  host = azurerm_databricks_workspace.this.workspace_url
}

variable "region" {
  type = string
  default = "westeurope"
}

resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 6
}

data "azurerm_client_config" "current" {
}

locals {
  prefix = "databricksdemo${random_string.naming.result}"
  tags = {
    Environment = "Demo"
  }
}

resource "azurerm_resource_group" "this" {
  name     = "${local.prefix}-rg"
  location = var.region
  tags     = local.tags
}

resource "azurerm_databricks_workspace" "this" {
  name                        = "${local.prefix}-workspace"
  resource_group_name         = azurerm_resource_group.this.name
  location                    = azurerm_resource_group.this.location
  sku                         = "premium"
  managed_resource_group_name = "${local.prefix}-workspace-rg"
  tags                        = local.tags
}

output "databricks_host" {
  value = "https://${azurerm_databricks_workspace.this.workspace_url}/"
}