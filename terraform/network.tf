resource "google_compute_network" "vpc" {
  name                    = "locartier-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "locartier-subnet"
  region        = var.region
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.vpc.id
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "locartier-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["locartier-ssh"]
}

resource "google_compute_firewall" "allow_web" {
  name    = "locartier-web"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = [tostring(var.web_port)]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["locartier-web"]
}