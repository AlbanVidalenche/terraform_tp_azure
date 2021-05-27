variable "location" {
    description = "Location where resources will be created"
    default = "France Central"
}

variable "resource_group_name" {
    description = "Name of the resource group"
    default = "terraform-src"
}


variable "application_port" {
    description = "Port exposed to the external loadbalancer"
    default = 80
}

# Databases Name

variable "mariadb_server_name" {
    description = "Database server name"
    default = "terraform-src-sulabs-mariadb-server-av"
}

# Databases Username

variable "mariadb_server_username" {
    type = string
    description = "Database admin server username"
    default = "sciencesu"
}


variable "tags" {
    description = " Maps of tags"
    type = map(string)
    
    default = {
        environment = "labs"
    }
}