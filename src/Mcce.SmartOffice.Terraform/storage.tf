resource "azurerm_storage_account" "storage" {
  name                     = "smartofficestorage${random_string.name-prefix.result}"
  resource_group_name      = azurerm_resource_group.resourcegroup.name
  location                 = azurerm_resource_group.resourcegroup.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "userimage-share" {
  name                 = "userimages"
  storage_account_name = azurerm_storage_account.storage.name
  quota                = 5
  depends_on           = [azurerm_storage_account.storage]
}

