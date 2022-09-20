# resource "azurerm_resource_group" "weightapp" {
#   name     = var.rg_name
#   location = var.rg_location
# }

resource "azurerm_network_security_group" "weightapp" {
  name                = "weightapp-security-group"
  location            = var.rg_location
  resource_group_name = var.rg_name

    depends_on = [
    azurerm_resource_group.wa
  ]
}

resource "azurerm_virtual_network" "weightapp" {
  name                = "weightapp-network"
  location            = var.rg_location
  resource_group_name = var.rg_name
  address_space       = ["10.0.0.0/28"]
  #   dns_servers         = ["10.0.0.4", "10.0.0.5"]

#   subnet {
#     name           = "backend"
#     address_prefix = "10.0.0.0/29"
#   }

#   subnet {
#     name           = "frontend"
#     address_prefix = "10.0.0.8/29"
#     security_group = azurerm_network_security_group.weightapp.id
#   }

  tags = {
    environment = "Production"
  }
      depends_on = [
    azurerm_resource_group.wa
  ]
}
resource "azurerm_subnet" "backendsub" {
  name                 = "backend"
  resource_group_name = var.rg_name
  virtual_network_name = azurerm_virtual_network.weightapp.name
  address_prefixes     = ["10.0.0.0/29"]
}

resource "azurerm_subnet" "frontendsub" {
  name                 = "frontend"
  resource_group_name = var.rg_name
  virtual_network_name = azurerm_virtual_network.weightapp.name
  address_prefixes     = ["10.0.0.8/29"]
}

resource "azurerm_network_interface" "weightapp" {
  name                = "weightapp-nic"
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.frontendsub.id
    private_ip_address_allocation = "Dynamic"
  }
  
}


resource "azurerm_public_ip" "ip" {
  name                = "ip"
  resource_group_name = var.rg_name
  location            = var.rg_location
  allocation_method   = "Static"
  sku                 = "Standard"

  idle_timeout_in_minutes = 30

}
