## Global ##
variable "prefix" {}

variable "machines" {
  description = "Cluster machines"
  type = map(object({
    node_type = string
    ip      = string
  }))
}

variable "gateway" {}
variable "dns_primary" {}
variable "dns_secondary" {}
variable "pool_id" {}
variable "datastore_id" {}
variable "guest_id" {}
variable "scsi_type" {}
variable "network_id" {}
variable "adapter_type" {}
variable "disk_thin_provisioned" {}
variable "template_id" {}
variable "firmware" {}
variable "folder" {}
variable "ssh_pub_key" {}
variable "hardware_version" {}

## Master ##
variable "master_cores" {}
variable "master_memory" {}
variable "master_disk_size" {}

## Worker ##
variable "worker_cores" {}
variable "worker_memory" {}
variable "worker_disk_size" {}
