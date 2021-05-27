terraform {
  required_providers {
    azurerm   = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "mysql" {
  endpoint = "${var.mariadb_server_name}.mariadb.database.azure.com"
  username = "${var.mariadb_server_user_name}@${var.mariadb_server_name}"
  password = random_password.administrator_mariadb_server_pwd.result
  tls      = false
}
