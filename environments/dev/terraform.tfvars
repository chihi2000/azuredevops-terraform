location            = "eastus"
resource_group_name = "Built-In-Identity-RG"
address_space       = ["10.1.0.0/16"]

# Subnets Configuration
subnets = {
  web = {
    name             = "dev-subnet-web"
    address_prefixes = ["10.1.1.0/24"]
    nsg_name         = "dev-nsg-web"
    security_rule = {
      name                       = "AllowHTTP"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
  app = {
    name             = "dev-subnet-app"
    address_prefixes = ["10.1.2.0/24"]
    nsg_name         = "dev-nsg-app"
    security_rule = {
      name                       = "AllowWebSubnet"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8080"
      source_address_prefixes    = ["10.1.1.0/24"]
      destination_address_prefix = "*"
    }
  }
  data = {
    name             = "dev-subnet-data"
    address_prefixes = ["10.1.3.0/24"]
    nsg_name         = "dev-nsg-data"
    security_rule = {
      name                       = "AllowAppSubnet"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "1433"
      source_address_prefixes    = ["10.1.2.0/24"]
      destination_address_prefix = "*"
    }
  }
}