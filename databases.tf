resource "random_password" "administrator_mariadb_server_pwd" {
    length      = 20
    min_upper   = 2
    min_lower   = 2
    min_numeric = 2
    min_special = 2
}

resource "azurerm_mariadb_server" "sulabs_src_terraform_mariadb" {
    name                = var.mariadb_server_name
    location            = var.location
    resource_group_name = var.resource_group_name

    sku_name = "B_Gen5_2"

    storage_mb                   = 10240
    backup_retention_days        = 7
    geo_redundant_backup_enabled = false

    administrator_login          = var.mariadb_server_username
    administrator_login_password = random_password.administrator_mariadb_server_pwd.result
    version                      = 10.3
    ssl_enforcement_enabled      = false
}

resource "azurerm_mariadb_database" "sulabs_src_terraform_mariadb_wordpress"{
  name = "wordpress"
  resource_group_name = var.resource_group_name
  server_name = azurerm_mariadb_server.sulabs_src_terraform_mariadb.name
  charset = "utf8"
  collation = "utf8_general_ci"
}

resource "azurerm_mariadb_firewall_rule" "sulabs_terraform_mariadb_firewall_rules"{
    name = "sulabs-terraform-vm-rule"
    resource_group_name = var.resource_group_name
    server_name = azurerm_mariadb_server.sulabs_src_terraform_mariadb.name
    start_ip_address = azurerm_public_ip.sulabs_src_terraform.ip_address
    end_ip_address = azurerm_public_ip.sulabs_src_terraform.ip_address
}
