resource "azurerm_kubernetes_cluster" "aks" {
    name                          = "aks-smartoffice-${random_string.name-prefix.result}"
    location                      = azurerm_resource_group.resourcegroup.location
    resource_group_name           = azurerm_resource_group.resourcegroup.name
    depends_on                    = [azurerm_user_assigned_identity.identity, azurerm_role_assignment.aks-identity-role]
    node_resource_group           = "${azurerm_resource_group.resourcegroup.name}-infra"
    dns_prefix                    = var.smartoffice_aks_dns_prefix
    sku_tier                      = "Free"    
    default_node_pool {
        name                      = "default"
        node_count                = 1
        vm_size                   = "Standard_B2s"
    }
    identity {
        type                      = "UserAssigned"
        identity_ids              = [azurerm_user_assigned_identity.identity.id]
    }
    kubelet_identity {
        client_id                 = azurerm_user_assigned_identity.identity.client_id
        object_id                 = azurerm_user_assigned_identity.identity.principal_id
        user_assigned_identity_id = azurerm_user_assigned_identity.identity.id
    }
    network_profile {
        network_plugin            = "kubenet"
        load_balancer_sku         = "basic"
    }
}