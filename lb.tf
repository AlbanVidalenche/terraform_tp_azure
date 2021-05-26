# Création du Load Balancer

resource "azurerm_lb" "sulabs_src_terrafrom_app_lb" {
    name                = "terrafrom_sulabs_src_loadbalancer"
    location            = var.location
    resource_group_name = var.resource_group_name

    frontend_ip_configuration {
        name                 = "terrafrom_sulabs_src_lb_public_ip"
        public_ip_address_id = azurerm_public_ip.sulabs_src_terraform.id
    }
}

# Création du pool d'addresse Backend

resource "azurerm_lb_backend_address_pool" "sulabs_src_terrafrom_backendpool" {
    loadbalancer_id = azurerm_lb.sulabs_src_terrafrom_app_lb.id
    name            = "sulabs_src_terrafrom_backend_addresspool"
}

# Création règle de routage

resource "azurerm_lb_rule" "sulabs_src_terrafrom_lb_nat_rule" {
    resource_group_name = var.resource_group_name
    loadbalancer_id = azurerm_lb.sulabs_src_terrafrom_app_lb.id
    name = "HTTP"
    protocol = "TCP"
    frontend_port = var.application_port
    backend_port = var.application_port
    backend_address_pool_id = azurerm_lb_backend_address_pool.sulabs_src_terrafrom_backendpool.id
    frontend_ip_configuration_name = "terrafrom_sulabs_src_lb_public_ip"
}
