resource "random_string" "fqdn" {
    length  = 6
    special = false
    upper   = false
    number  = false
}

resource "azurerm_virtual_network" "sulabs_src_vnet" {
  name = "terraform_sulabs_src_vnet"
  address_space = ["10.0.0.0/16"]
  location = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags
}

resource "azurerm_subnet" "sulabs_src_subnet" {
 name = "terraform_sulabs_src_subnet"
 resource_group_name = var.resource_group_name
 virtual_network_name = azurerm_virtual_network.sulabs_src_vnet.name
 address_prefixes = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "sulabs_src_terraform"{
  name = "terraform_sulabs_src_public_ip"
  location = var.location
  resource_group_name = var.resource_group_name
  allocation_method = "Static"
  domain_name_label   = random_string.fqdn.result
  
}

resource "azurerm_public_ip" "sulabs_src_terraform_jumpbox_public_ip" {
    name = "terraform_sulabs_jumpbox_public_ip"
    location = var.location
    resource_group_name = var.resource_group_name
    allocation_method = "Static"
    domain_name_label = "${random_string.fqdn.result}-ssh"
}
