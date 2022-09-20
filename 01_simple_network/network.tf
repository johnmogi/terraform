# resource "azurerm_resource_group" "weightapp" {
#   name     = var.rg_name
#   location = var.rg_location
# }

resource "azurerm_network_security_group" "weightapp" {
  name                = "weightapp-security-group"
  location            = var.rg_location
  resource_group_name = var.rg_name
}

resource "azurerm_virtual_network" "weightapp" {
  name                = "weightapp-network"
  location            = var.rg_location
  resource_group_name = var.rg_name
  address_space       = ["10.0.0.0/28"]
  #   dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "backend"
    address_prefix = "10.0.0.0/29"
  }

  subnet {
    name           = "frontend"
    address_prefix = "10.0.0.8/29"
    security_group = azurerm_network_security_group.weightapp.id
  }

  tags = {
    environment = "Production"
  }
}