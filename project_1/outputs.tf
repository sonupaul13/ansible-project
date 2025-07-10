output "vm_public_ips" {
  value = [
    for vm in values(module.vm_instance.vm_public_ips) : {
      ip       = vm.ip
      username = vm.username
      tags     = [
        for k, v in try(vm.tags, {}) :
        k if v == "true" && contains(["mongo", "postgres", "solr"], k)
      ]
    }
  ]
}