terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.11.0"
    }
  }
}

provider "google" {
  project = var.ProjectID
  region  = var.Location
  zone    = "${var.Location}-c"
}

############################
#SERVIDOR ORACLE EN GCP    #
############################
module "gcp" {
source                                = "../modulos/gcp"
ProjectID                             = var.ProjectID
Location                              = var.Location
auto_create_subnetworks               = var.auto_create_subnetworks
routing_mode                          = var.routing_mode
delete_default_internet_gateway_routes= var.delete_default_internet_gateway_routes
}

                             
                              
               
                          
               
