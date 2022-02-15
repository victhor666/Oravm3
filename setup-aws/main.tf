############################
SERVIDOR ORACLE EN AWS    #
############################
provider "aws" {
  profile    = "${var.Profile}"
  region     = "${var.Location}"
}

 module "aws" {
 source = "../modulos/aws"
 Proyecto=var.Proyecto
 Location=var.Location
 }