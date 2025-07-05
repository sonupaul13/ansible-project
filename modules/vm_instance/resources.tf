resource "google_compute_instance" "vm_sandeep_tf" {
  for_each     = { for vm in var.instances : vm.name => vm }

  name         = each.value.name
  machine_type = each.value.machine_type
  zone         = each.value.zone
  can_ip_forward = false
  tags           = ["http-server", "https-server", "allow-ssh", "ssh"]

  boot_disk {
    initialize_params {
      image = each.value.image
      size  = 20
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }

  metadata = {
    ssh-keys = "${each.value.username}:${base64decode(var.ssh_public_key)}"
  }
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}
