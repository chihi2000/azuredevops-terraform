module "vnet" {
  source              = "../../modules/networking/vnet"
  vnet_name           = "dev-vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  subnets             = var.subnets

  tags = {
    Environment = "Dev"
    Owner       = "DevOps"
  }
}