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
  tags = {
    environment = "Production"
  }
  depends_on = [
    azurerm_resource_group.wa
  ]
}
resource "azurerm_subnet" "backendsub" {
  name                 = "backend"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.weightapp.name
  address_prefixes     = ["10.0.0.0/29"]
}

resource "azurerm_subnet" "frontendsub" {
  name                 = "frontend"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.weightapp.name
  address_prefixes     = ["10.0.0.8/29"]
}


resource "azurerm_public_ip" "ip" {
  name                    = "ip"
  resource_group_name     = var.rg_name
  location                = var.rg_location
  allocation_method       = "Static"
  sku                     = "Standard"
  idle_timeout_in_minutes = 30
  depends_on              = [azurerm_resource_group.wa]
}

resource "azurerm_public_ip" "frontend_ip" {
  name                    = "weight_app_frontend_ip"
  resource_group_name     = var.rg_name
  location                = var.rg_location
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  depends_on = [azurerm_resource_group.wa]
}

# frontend network interface for the app
resource "azurerm_network_interface" "frontend_nic" {
  name = "frontend_nic"
  # name                = "frontend_${var.frontend_machine}-nic"
  resource_group_name = var.rg_name
  location            = var.rg_location

  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.frontend_ip.id
    subnet_id                     = azurerm_subnet.frontendsub.id

  }
  # Making sure resource group and subnet exists prior to connection
  depends_on = [
    azurerm_resource_group.wa,
    azurerm_subnet.frontendsub
  ]

}

# frontend network interface for the app
resource "azurerm_network_interface" "backend_nic" {
  name = "backend_nic"
  # name                = "backend_${var.backend_machine}-nic"
  resource_group_name = var.rg_name
  location            = var.rg_location

  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id          = azurerm_public_ip.backend_ip.id
    subnet_id = azurerm_subnet.backendsub.id

  }
  # Making sure resource group and subnet exists prior to connection
  depends_on = [
    azurerm_resource_group.wa,
    azurerm_subnet.backendsub
  ]

}