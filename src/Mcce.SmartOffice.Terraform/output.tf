output "resource-group-name" {
    value = azurerm_resource_group.resourcegroup.name
}

output "storage-account-name" {
    value = azurerm_storage_account.storage.name
}

output "app-configuration-endpoint" {
  value = azurerm_app_configuration.appconfig.endpoint
}

output "aks-cluster-name" {
    value = azurerm_kubernetes_cluster.aks.name
}