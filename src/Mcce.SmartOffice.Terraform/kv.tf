resource "azurerm_key_vault" "kv" {
    name                          = "kv-smartoffice-${random_string.name-prefix.result}"
    location                      = azurerm_resource_group.resourcegroup.location
    resource_group_name           = azurerm_resource_group.resourcegroup.name
    enabled_for_disk_encryption   = false
    tenant_id                     = data.azurerm_client_config.current.tenant_id
    soft_delete_retention_days    = 7
    purge_protection_enabled      = false
    enable_rbac_authorization     = true
    sku_name = "standard"
}

resource "azurerm_key_vault_secret" "mqttconfig-password" {
  name         = "mqttconfig--password"
  value        = var.smartoffice_mqtt_password
  key_vault_id = azurerm_key_vault.kv.id
  depends_on    = [azurerm_role_assignment.kv-admin-role]
}

resource "azurerm_key_vault_secret" "dbconfig-connectionstring" {
  name          = "dbconfig--connectionstring"
  value         = azurerm_cosmosdb_account.db.primary_sql_connection_string
  key_vault_id  = azurerm_key_vault.kv.id
  depends_on    = [azurerm_cosmosdb_account.db, azurerm_role_assignment.kv-admin-role]
}