module "vnet" {
  source              = "../../modules/networking/vnet"
  vnet_name           = "dev-vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.1.0.0/16"]
  tags = {
    Environment = "Dev"
    Owner       = "DevOps"
  }
}