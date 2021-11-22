
resource "azurerm_container_registry" "devops" {
  name                = var.kubernetes_cluster_name
  resource_group_name = azurerm_resource_group.devops.name
  location            = azurerm_resource_group.devops.location
  sku                 = "standard"
  admin_enabled       = true
}