terraform {
  backend "azurerm" {
    resource_group_name   = "Built-In-Identity-RG"
    storage_account_name  = "tfstateprod2025"
    container_name        = "tfstate"
    key                   = "dev.terraform.tfstate"
  }
}
