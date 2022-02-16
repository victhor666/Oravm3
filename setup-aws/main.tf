############################
#SERVIDOR ORACLE EN AWS    #
############################
provider "aws" {
  profile    = "${var.Profile}"
  region     = "${var.Location}"
}

 module "aws" {
 source = "../modulos/aws"
 }