output "vm_public_ips" {
  value = {
    for idx, vm in var.instances :
    vm.name => {
      ip       = google_compute_instance.vm_sandeep_tf[vm.name].network_interface[0].access_config[0].nat_ip
      username = vm.username
      tags     = vm.tags
    }
  }
}
