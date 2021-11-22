#### Vars for authenticating to Azure ####
variable "client_id" {
    description =   "Client ID (APP ID) of the application"
    type        =   string
}

variable "client_secret" {
    description =   "Client Secret (Password) of the application"
    type        =   string
}

variable "subscription_id" {
    description =   "Subscription ID"
    type        =   string
}

variable "tenant_id" {
    description =   "Tenant ID"
    type        =   string
}
#### Global Vars like, name and locations ####
variable "rg_name" {
  default = "devops-infra-rg"
}

variable "location" {
  default = "eastus"
}

variable "environment" {
  default = "staging"
}
variable "vnet_name" {
  default = "devops-vnet"
}
### Vars for Linux VM ###
variable "linux_vms_admin_username" {
  default = "ahmed"
}

variable "linux_vms_public_ip_dns" {
  type        = list
  default     = [["abouhamed-jenkins-master"],["abouhamed-jenkins-worker"],["abouhamed-sonar"]]
}

variable "linux_vms_count" {
  default = 3
}
variable "linux_vms_ssh_key" {
  default = "" # from jenkins credentials
}
variable "linux_vms_vm_hostname" {
  type        = list
  default     = ["jenkins-master","jenkins-worker","sonar"]
}

variable "linux_vms_vm_size"{
    default = "Standard_DS1_v2"
}
### Vars for AKS ###
variable "kubernetes_cluster_name" {
  default = "abouhameddevops"
}
variable "kubernetes_cluster_location" {
  default = "westus"
}
variable "kubernetes_cluster_ssh_pub" {
  type = string
}
variable "kubernetes_cluster_node_count" {
  default = 2
}
variable "kubernetes_cluster_node_vm_size" {
  default = "Standard_B2ms"
}
