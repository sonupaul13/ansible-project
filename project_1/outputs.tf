output "vm_public_ips" {
  value = [
    for vm in module.vm_instance.vm_public_ips : vm
  ]
}