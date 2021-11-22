resource "azurerm_resource_group" "devops" {
  name = var.rg_name
  location = var.location
  tags = {
    "environment" = var.environment
    "creator" = "terraform"
  }
}

module "network" {
  source              = "Azure/network/azurerm"
  vnet_name           = var.vnet_name
  resource_group_name = azurerm_resource_group.devops.name
  address_spaces      = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24"]
  subnet_names        = ["server-sub", "vms-sub"]


  tags = {
    environment = "dev"
    costcenter  = "it"
  }

  depends_on = [azurerm_resource_group.devops]
}

module "linuxservers" {
    count = 3
    source              = "Azure/compute/azurerm"
    resource_group_name = azurerm_resource_group.devops.name
    vm_os_publisher     = "Canonical"
    vm_os_offer         = "UbuntuServer"
    vm_os_sku           = "16.04-LTS"
    vm_os_version       = "latest"
    vm_size             = var.linux_vms_vm_size
    public_ip_dns       = element(var.linux_vms_public_ip_dns, count.index)
    vnet_subnet_id      = module.network.vnet_subnets[1]
    admin_username      = var.linux_vms_admin_username
    delete_os_disk_on_termination = true    # chnage in production
    location            = var.location
    enable_ssh_key      = true
    ssh_key             = var.linux_vms_ssh_key
    remote_port         = "22"
    vm_hostname         = element(var.linux_vms_vm_hostname, count.index)

    depends_on = [azurerm_resource_group.devops]
}
