variable "location" {
    description = "Location where resources will be created"
    default = "France Central"
}

variable "resource_group_name" {
    description = "Name of the resource group"
    default = "terraform-src"
}
variable "tags" {
    description = " Maps of tags"
    type = map(string)
    
    default = {
        environment = "labs"
    }
}