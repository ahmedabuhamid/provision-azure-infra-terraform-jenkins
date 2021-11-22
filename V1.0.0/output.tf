output "subnet_id" {
    value = module.network.vnet_subnets
}

output "cluster_kube_config" {
  value = azurerm_kubernetes_cluster.cluster.kube_config_raw
  sensitive = true

}
