output "vm_public_ips" {
  value = {
    for k, vm in google_compute_instance.vm_sandeep_tf :
    k => {
      ip       = vm.network_interface[0].access_config[0].nat_ip
      username = vm.metadata["ssh-keys"] != null ? split(":", vm.metadata["ssh-keys"])[0] : "ansible-user"
      tags     = var.instances[k].tags
    }
  }
}
