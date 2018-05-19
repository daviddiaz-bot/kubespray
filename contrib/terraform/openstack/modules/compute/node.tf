
resource "openstack_networking_port_v2" "k8s_node_port" {
  count          = "${var.number_of_k8s_nodes}"
  name           = "${var.cluster_name}-k8s-node-${count.index+1}-port"
  network_id     = "${var.network_id}"
  admin_state_up = true
  device_owner   = "compute:nova"

  allowed_address_pairs {
    ip_address = "${var.kube_service_addresses}"
  }

  allowed_address_pairs {
    ip_address = "${var.kube_pods_subnet}"
  }

}


resource "openstack_compute_instance_v2" "k8s_node" {
  name       = "${var.cluster_name}-k8s-node-${count.index+1}"
  count      = "${var.number_of_k8s_nodes}"
  image_name = "${var.image}"
  flavor_id  = "${var.flavor_k8s_node}"
  key_pair   = "${openstack_compute_keypair_v2.k8s.name}"

  network {
    port = "${element(openstack_networking_port_v2.k8s_node_port.*.id, count.index)}"
  }

  security_groups = [
    "${openstack_compute_secgroup_v2.k8s.name}",
    "${openstack_compute_secgroup_v2.bastion.name}",
    "default",
  ]

  metadata {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "kube-node,k8s-cluster"
    depends_on       = "${var.network_id}"
  }

}


resource "openstack_compute_instance_v2" "k8s_node_no_floating_ip" {
  name       = "${var.cluster_name}-k8s-node-nf-${count.index+1}"
  count      = "${var.number_of_k8s_nodes_no_floating_ip}"
  image_name = "${var.image}"
  flavor_id  = "${var.flavor_k8s_node}"
  key_pair   = "${openstack_compute_keypair_v2.k8s.name}"

  network {
    port = "${element(openstack_networking_port_v2.k8s_node_port.*.id, count.index)}"
  }

  security_groups = [
    "${openstack_compute_secgroup_v2.k8s.name}",
    "default",
  ]

  metadata {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "kube-node,k8s-cluster,no-floating"
    depends_on       = "${var.network_id}"
  }

}


resource "openstack_compute_floatingip_associate_v2" "k8s_node" {
  count       = "${var.number_of_k8s_nodes}"
  floating_ip = "${var.k8s_node_fips[count.index]}"
  instance_id = "${element(openstack_compute_instance_v2.k8s_node.*.id, count.index)}"
}
