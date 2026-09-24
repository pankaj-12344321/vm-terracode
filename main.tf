
data "google_compute_image" "my_image" {
  family  = "debian-12"
  project = "debian-cloud"
}


resource "google_compute_instance" "myinstance"{

    for_each = toset(var.iname)
  name = each.key
  machine_type = "n2-standard-2"
  zone         = "us-central1-a"

  tags = ["foo", "bar"]

   boot_disk {
    initialize_params {
      image = data.google_compute_image.my_image.self_link
    }
  }


  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = google_compute_network.mynet.name
    subnetwork = google_compute_subnetwork.my-subnet.name


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
    auto_create_subnetworks = false
   
}

resource "google_compute_subnetwork" "my-subnet" {
  name = "vpc-subnet"
  region = var.region
  network = google_compute_network.mynet.id
  ip_cidr_range = "10.0.0.0/28"
}