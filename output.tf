output "sulabs_terraform_src_public_fqdn" {
    value = azurerm_public_ip.sulabs_src_terraform.fqdn
}

output "sulabs_terraform_lb_public_ip" {
    value = azurerm_public_ip.sulabs_src_terraform.ip_address
}

output "sulabs_terraform_jumpbox_public_ip" {
    value = azurerm_public_ip.sulabs_src_terraform_jumpbox_public_ip.ip_address
}
