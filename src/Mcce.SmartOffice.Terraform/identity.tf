# managed identity
resource "azurerm_user_assigned_identity" "identity" {
  location            = azurerm_resource_group.resourcegroup.location
  name                = "id-smartoffice-${random_string.name-prefix.result}"
  resource_group_name = azurerm_resource_group.resourcegroup.name
}