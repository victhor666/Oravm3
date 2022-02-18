provider "google" {
# credentials = file("CREDENTIALS_FILE.json")
 project     = var.ProjectID
 region      = var.Location
}


/******************************************
	VPC configuration
 *****************************************/

resource "google_compute_network" "vpc_network" {
  project                         = var.ProjectID
  name                            = "${var.ProjectID}-VPC"
  routing_mode                    = var.routing_mode
  auto_create_subnetworks         = var.auto_create_subnetworks
  description                     = "Red general de despliegue para proyect ${var.ProjectID}"
  delete_default_routes_on_create = var.delete_default_internet_gateway_routes
}



# /******************************************
# 	DISCOS
#  *****************************************/
# resource "google_compute_disk" "default" {
#   name  = "test-disk"
#   type  = "pd-ssd"
#   zone  = "us-central1-a"
#   image = "debian-9-stretch-v20200805"
#   labels = {
#     environment = "dev"
#   }
#   physical_block_size_bytes = 4096
# }

/******************************************
	firewall
 *****************************************/
resource "google_compute_firewall" "default" {
  name    = "test-firewall"
  network = google_compute_network.default.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["web"]
}

resource "google_compute_network" "default" {
  name = "test-network"
}