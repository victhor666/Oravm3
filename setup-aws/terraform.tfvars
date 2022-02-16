
#PROYECTO
Proyecto = "Oracle"
Location = "eu-central-1"
#RED
vpc_cidr                = "192.168.0.0/16"
subnet_cidr             = "192.168.10.0/24"
private_ip              = "192.168.10.51"
map_public_ip_on_launch = true
#SERVIDOR
boot_volume_size_in_gbs   = 30
instance_type             = "t2.small"
ami_id                    = "ami-0484afc52074f4f84"
block_storage_size_in_gbs = 20
VOL-ORACLE-SIZE           = 25
VOL-DATA-SIZE             = 10
ebs_volume_type           = "gp2"
Profile                   = "default"