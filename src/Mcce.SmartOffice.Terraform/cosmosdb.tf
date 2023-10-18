resource "azurerm_cosmosdb_account" "db" {
    name                            = "db-smartoffice-${random_string.name-prefix.result}"
    location                        = azurerm_resource_group.resourcegroup.location
    resource_group_name             = azurerm_resource_group.resourcegroup.name
    offer_type                      = "Standard"
    kind                            = "GlobalDocumentDB"
    enable_automatic_failover       = false
    capabilities {
        name = "EnableServerless"
    }
    consistency_policy {
        consistency_level           = "Session"
        max_interval_in_seconds     = 5
        max_staleness_prefix        = 100
    }
    geo_location {
        location                    = "westeurope"
        failover_priority           = 0
    }
}