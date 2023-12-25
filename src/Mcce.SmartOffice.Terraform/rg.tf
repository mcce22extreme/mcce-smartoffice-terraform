resource "azurerm_resource_group" "resourcegroup" {
  name     = "${var.azure_resourcegroup}-${random_string.name-prefix.result}"
  location = var.azure_location
}