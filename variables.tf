variable "resource_group_name" {
  default = "portfoliobi_rg"
}

variable "location" {
  default = "East US"
}

variable "vnet_name" {
  default = "vnet-azure"
}

variable "subnets" {
  default = {
    "linux"  = "10.0.1.0/24"
    "windows" = "10.0.2.0/24"
  }
}

variable "vms" {
  type = map(object({
    size           = string
    admin_username = string
    os_type        = string
  }))
  default = {
    windows = {
      size           = "Standard_B2s"
      admin_username = "adminuser"
      os_type        = "Windows"
    }
    linux = {
      size           = "Standard_B2s"
      admin_username = "adminuser"
      os_type        = "Linux"
    }
  }
}