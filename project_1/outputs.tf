output "vm_public_ips" {
  value = [
    for vm in values(module.vm_instance.vm_public_ips) : {
      ip       = vm.ip
      username = vm.username
      role = vm.role
      run_os_upgrade = vm.run_os_upgrade
    }
  ]
}