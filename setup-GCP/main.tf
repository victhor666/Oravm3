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
  credentials = var.gcp_credentials
  region      = var.Location
  zone        = "${var.Location}-c"
}

############################
#SERVIDOR ORACLE EN GCP    #
############################
module "gcp" {
source                                = "../modulos/gcp"
ProjectID                             = var.ProjectID
Prefijo                               = var.Prefijo
Location                              = var.Location
auto_create_subnetworks               = var.auto_create_subnetworks
routing_mode                          = var.routing_mode
delete_default_internet_gateway_routes= var.delete_default_internet_gateway_routes
}

                             
                              
               
                          
               
