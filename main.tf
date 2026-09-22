
resource "google_compute_instance" "myinstance"{

    for_each = toset(var.iname)
  name = each.key
  machine_type = "n2-standard-2"
  zone         = "us-central1-a"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  
}


resource "google_compute_network" "mynet"{
    name = "vm-vpc"
   
}

resource "google_compute_subnetwork" "my-subnet" {
  name = "vpc-subnet"
  region = var.region
  network = google_compute_network.mynet.id
  ip_cidr_range = "10.0.0.0/28"
}