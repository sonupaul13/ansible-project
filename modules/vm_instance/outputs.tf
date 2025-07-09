output "vm_public_ips" {
  value = {
    for name, vm in google_compute_instance.vm_sandeep_tf :
    name => {
      ip = vm.network_interface[0].access_config[0].nat_ip
      username = vm.metadata["ssh-keys"] != null ? split(":", vm.metadata["ssh-keys"])[0] : null
      role = vm.tags[4]
    }
  }
}
