

# network_security_group
resource "azurerm_network_security_group" "frontend_nsg" {
  name                = "frontend_NSG"
  resource_group_name = var.rg_name
  location            = var.rg_location

  # SSH 
  security_rule {
    name                       = "SSH"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 22
    destination_address_prefix = "10.0.0.8/29"

    #  permission to ssh 
    source_address_prefix = "10.0.0.8/29"
  }

  # Allow HTTP on port 8080
  security_rule {
    name                       = "HTTP"
    priority                   = 800
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 8080
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.0.8/29"
  }

  depends_on = [azurerm_virtual_network.weightapp]
}

# connecting [SUBNET] to nsg
resource "azurerm_subnet_network_security_group_association" "frontend_subnet" {
  network_security_group_id = azurerm_network_security_group.frontend_nsg.id
  subnet_id                 = azurerm_subnet.frontendsub.id
}
# connecting [NIC] to nsg

resource "azurerm_network_interface_security_group_association" "fe_nsg_connect" {
  network_interface_id      = azurerm_network_interface.frontend_nic.id
  network_security_group_id = azurerm_network_security_group.frontend_nsg.id
}


# BE network_security_group
resource "azurerm_network_security_group" "backend_nsg" {
  name                = "backend_NSG"
  resource_group_name = var.rg_name
  location            = var.rg_location

  # SSH 
  security_rule {
    name                       = "SSH"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 22
    destination_address_prefix = "10.0.0.0/29"

    #  permission to ssh 
    source_address_prefix = "10.0.0.0/29"
  }


  depends_on = [azurerm_virtual_network.weightapp]
}

# connecting BE [SUBNET] to nsg
resource "azurerm_subnet_network_security_group_association" "backend_subnet" {
  network_security_group_id = azurerm_network_security_group.backend_nsg.id
  subnet_id                 = azurerm_subnet.backendsub.id
}
# connecting BE [NIC] to nsg

resource "azurerm_network_interface_security_group_association" "be_nsg_connect" {
  network_interface_id      = azurerm_network_interface.backend_nic.id
  network_security_group_id = azurerm_network_security_group.backend_nsg.id
}