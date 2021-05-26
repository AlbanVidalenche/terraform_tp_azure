resource "azurerm_network_interface" "sulabs_src_terraform_jumpbox_nic" {
    name = "terraform_sulabs_jumpbox_nic"
    location = var.location
    resource_group_name = var.resource_group_name

    ip_configuration {
        name = "IPConfiguration"
        subnet_id = azurerm_subnet.sulabs_src_subnet.id
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = azurerm_public_ip.sulabs_src_terraform_jumpbox_public_ip.id
    }

    tags = var.tags
}

resource "azurerm_virtual_machine" "sulabs_src_terraform_jumpbox" {
    name = "jumpbox"
    location = var.location
    resource_group_name = var.resource_group_name
    network_interface_ids = [azurerm_network_interface.sulabs_src_terraform_jumpbox_nic.id]
    vm_size = "Standard_B1ls"

    storage_image_reference {
        publisher = "Debian"
        offer = "debian-10"
        sku = 10
        version = "latest"
    }

    storage_os_disk {
        name = "jumpbox_osdisk"
        caching = "ReadWrite"
        create_option = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    os_profile {
        computer_name = "Jumpbox"
        admin_username = "sciencesu"
        admin_password = ""
    
    }

    os_profile_linux_config {
        disable_password_authentication = true
    
        ssh_keys {
            path = "/home/sciencesu/.ssh/authorized_keys"
            key_data = file("~/.ssh/id_rsa.pub")
        }

    }
        tags = var.tags
}