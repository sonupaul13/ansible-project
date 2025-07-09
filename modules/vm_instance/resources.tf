resource "google_compute_disk" "extra_disk" {
  for_each = {for vm in var.instances : vm.name => vm}
  name = "${each.key}-extra-disk"
  type = "pd-standard"
  zone = each.value.zone
  size = 50
}

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

  attached_disk {
    source      = google_compute_disk.extra_disk[each.key].self_link
    device_name = "extra-disk"
    mode        = "READ_WRITE"
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
