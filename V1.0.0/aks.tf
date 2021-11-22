resource "azurerm_kubernetes_cluster" "cluster" {
    name                = var.kubernetes_cluster_name
    location            = var.kubernetes_cluster_location
    resource_group_name = azurerm_resource_group.devops.name
    dns_prefix          = var.kubernetes_cluster_name

    linux_profile {
        admin_username = var.linux_vms_admin_username

        ssh_key {
            key_data = var.kubernetes_cluster_ssh_pub
        }
    }

    default_node_pool {
        name            = "default"
        node_count      = var.kubernetes_cluster_node_count
        vm_size         = var.kubernetes_cluster_node_vm_size
    }

    service_principal {
        client_id     = var.client_id
        client_secret = var.client_secret
    }
}