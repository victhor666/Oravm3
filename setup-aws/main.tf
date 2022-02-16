############################
#SERVIDOR ORACLE EN AWS    #
############################
provider "aws" {
  profile = var.Profile
  region  = var.Location
}

module "aws" {
  source                    = "../modulos/aws"
  Location                  = var.Location
  Proyecto                  = var.Proyecto
  vpc_cidr                  = var.vpc_cidr
  subnet_cidr               = var.subnet_cidr
  private_ip                = var.private_ip
  map_public_ip_on_launch   = var.map_public_ip_on_launch
  boot_volume_size_in_gbs   = var.boot_volume_size_in_gbs
  instance_type             = var.instance_type
  ami_id                    = var.ami_id
  block_storage_size_in_gbs = var.block_storage_size_in_gbs
  VOL-ORACLE-SIZE           = var.VOL-ORACLE-SIZE
  VOL-DATA-SIZE             = var.VOL-DATA-SIZE
  ebs_volume_type           = var.ebs_volume_type
}