resource "azurerm_container_registry" "acr" {
  name                      = "acrsmartoffice${random_string.name-prefix.result}"
  resource_group_name       = azurerm_resource_group.resourcegroup.name
  location                  = azurerm_resource_group.resourcegroup.location
  sku                       = "Basic"
}