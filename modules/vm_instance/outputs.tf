# output "vm_public_ips" {
#   value = {
#     for name, vm in google_compute_instance.vm_sandeep_tf :
#     name => {
#       ip = vm.network_interface[0].access_config[0].nat_ip
#       username = var.vms[name].username
#       role = var.vms[name].tags[4]
#     }
#   }
# }

output "vm_public_ips" {
  value = {
    for name, inst in local.instance_map :
    name => {
      ip       = google_compute_instance.vm[name].network_interface[0].access_config[0].nat_ip
      username = inst.username
      role     = inst.role
    }
  }
}
