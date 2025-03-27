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
  type = map(string)
  default = {
    windows = "subnet-windows"
    linux   = "subnet-linux"
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