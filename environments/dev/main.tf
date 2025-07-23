module "vnet" {
  source              = "../../modules/networking/vnet"
  vnet_name           = "dev-vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  tags = {
    Environment = "Dev"
    Owner       = "DevOps"
  }
}