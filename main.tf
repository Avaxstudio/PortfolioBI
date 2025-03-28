
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnets
  name                 = each.value
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value]
}

resource "azurerm_network_security_group" "nsg" {
  for_each            = var.subnets
  name                = "nsg-${each.key}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowRDP_SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = each.key == "windows" ? ["3389"] : ["22"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "nic" {
  for_each            = var.vms
  name                = "nic-${each.key}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig-${each.key}"
    subnet_id                     = azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[each.key].id
  }
}

resource "azurerm_public_ip" "pip" {
  for_each            = var.vms
  name                = "pip-${each.key}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_windows_virtual_machine" "win_vm" {
  for_each            = { for key, vm in var.vms : key => vm if vm.os_type == "Windows" }
  name                = "vm-${each.key}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = each.value.size
  admin_username      = each.value.admin_username
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  admin_password = "PortfolioB1!"
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  for_each            = { for key, vm in var.vms : key => vm if vm.os_type == "Linux" }
  name                = "vm-${each.key}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = each.value.size
  admin_username      = each.value.admin_username
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = each.value.admin_username
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDdaeeXX+HKY+EPxDWx1NkQ7dp9rWM4eGUQCwHSOiEa9yEwBqijQb78+RsxunpJ/WAZNol8jmYhK0lIz4CDvpHsFBmh3uByT6TRESssfeu99ur2ZRiVLCmS6CI/usR1OTo7AUmqESMoVZ4zoR6AsKTpAzh16MWHZJYR8avDoPUBu01UkQQinlgvXJD7eRhRmRR1uiVO53tdcZBDiO0VBxTsxJ6KSOfwM3boLRAofpqQ3r8VhWXySSej5Msd8d/PPpdoK9gKGlIntcVtcsBc8C0HUwXGKwpmUwmlIGP3Zp7PKb2wG4I5erAZV5CrveDjD6wjyEoOfqdvbhAVUdNa6XBNv4vHj5JR7vpLX4KXDqvFMVoq4oVCTjPqEOfQrheR9rNkgFmfnv5g7YXaLfB4E0LRpt0UYIQkkqjtP5l0ZJQDaLDcKtnkOSyc4dzp4WCI02HHgDB37NNQKR3eDUNYMaCYE46FmtYOkvogtwILswkQl417YSYbsju1ziVzKgAZlWUGiYpR0N9dqkQzy83sGC6FR+dqjkxvKG5ZPHfuOwljznsShJ1byU1TyeXE2EMJr8j/5T7oorIaiHrFO7t/F9JSsoiQE5+x0H/WdZ57fhxQ/KtCNkG5WlUQr8/QlcM3shbsZVD20J6FTyZF50LiioTL7NQ8EdVdZh75ENQxTSSKSw== vlaja45@gmail.com"
  }
}
