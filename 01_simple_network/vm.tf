
# azurerm_linux_virtual_machine vs azurerm_virtual_machine 
resource "azurerm_linux_virtual_machine" "frontend_vm" {
  name = "frontend_vm"
  #   resource_group_name = var.rg_name
  location       = var.rg_location
  computer_name  = "frontendVm"
  admin_username = var.admin_username
  admin_password = var.admin_password

  network_interface_ids           = [azurerm_network_interface.frontend_nic.id]
  resource_group_name             = azurerm_resource_group.wa.name
  size                            = var.size
  disable_password_authentication = false

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/weightapp.pub")
  }

  os_disk {
    name                 = "frontend_disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

    depends_on = [azurerm_virtual_network.weightapp]

}
