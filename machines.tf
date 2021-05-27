# Création des interfaces (avec la boucle "count")

resource "azurerm_network_interface" "sulabs_src_terraform" {
    count               = 2
    name                = "terraform_sulabs_nic_${count.index}"
    location            = var.location
    resource_group_name = var.resource_group_name

    ip_configuration {
        name                          = "sulabs_src_backend_ip_configuration"
        subnet_id                     = azurerm_subnet.sulabs_src_subnet.id
        private_ip_address_allocation = "dynamic"
    }
}

# Création de l'availability set

resource "azurerm_availability_set" "sulabs_src_terraform_avset" {
    name                         = "terraform_sulabs_src_avset"
    location                     = var.location
    resource_group_name          = var.resource_group_name
    platform_fault_domain_count  = 2
    platform_update_domain_count = 2
    managed                      = true
}

# Création de la VM

resource "azurerm_virtual_machine" "sulabs_src_terraform" {
    count                 = 2
    name                  = "terraform_sulabs_src_vm_${count.index}"
    location              = var.location
    resource_group_name   = var.resource_group_name
    availability_set_id   = azurerm_availability_set.sulabs_src_terraform_avset.id
    network_interface_ids = [element(azurerm_network_interface.sulabs_src_terraform.*.id, count.index)]
    vm_size               = "Standard_B1ls"

    # Définir l'OS de la VM

    storage_image_reference {
        publisher = "Debian"
        offer     = "debian-10"
        sku       = 10
        version   = "latest"
    }

    # Définir le disque pour l'OS

    storage_os_disk {
        name              = "terraform_sulabs_src_osdisk_${count.index}"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    # Définir le profil de la VM

    os_profile {
        computer_name  = "web-${count.index}"
        admin_username = "sciencesu"
        admin_password = ""
        custom_data = file("files/init.conf")
    }

    # Définir les parametres linux

    os_profile_linux_config {
        disable_password_authentication = true

        ssh_keys {
            path     = "/home/sciencesu/.ssh/authorized_keys"
            key_data = file("~/.ssh/id_rsa.pub")
        }
    }

    tags = "${merge(var.tags, {ansible_group = "web"})}"    
}

resource "azurerm_network_interface_backend_address_pool_association" "sulabs_src_terraform_backend_pool_association" {
  count                   = 2
  network_interface_id    = "${element(azurerm_network_interface.sulabs_src_terraform.*.id,count.index)}"
  ip_configuration_name   = "sulabs_src_backend_ip_configuration"
  backend_address_pool_id = azurerm_lb_backend_address_pool.sulabs_src_terraform_backendpool.id
}