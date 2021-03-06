resource "azurerm_key_vault" "devops" {
  name                        = "abouhamed-devopskeyvault"
  location                    = azurerm_resource_group.devops.location
  resource_group_name         = azurerm_resource_group.devops.name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.client_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}