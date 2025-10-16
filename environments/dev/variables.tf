variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "address_space" {
  type = list(string)
}

# Subnets Configuration
variable "subnets" {
  description = "Map of subnets with their configurations"
  type = map(object({
    name             = string
    address_prefixes = list(string)
    nsg_name         = string
    security_rule = object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = optional(string)
      source_address_prefixes    = optional(list(string))
      destination_address_prefix = string
    })
  }))
}