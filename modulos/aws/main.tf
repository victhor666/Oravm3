terraform {
      required_version = ">= 0.12.0"
    }
# Provider specific configs
# Mejor no usar esto y logarse en el sistema con aws configure, y luego lanzar el tf con dicho usuairo
#provider "aws" {
#    access_key = "${var.aws_access_key}"
#    secret_key = "${var.aws_secret_key}"
#    region = var.Region-aws
#}
###########################################
# Datos de las zonas de  de disponibilidad 
#Obtenemos las zonas de disponibilidad activas para esa region
data "aws_availability_zones" "Oracle-AD" {
  state = "available"
  filter {
    name   = "region-name"
    values =[var.Location]
  }
}    
#################
# VPC

resource "aws_vpc" "Oracle-VPC" {
    cidr_block                       = var.vpc_cidr
    tags                             = {
        "Name"                       = "${var.Proyecto}-VPC"
    }
}
#################
# SUBNET


resource "aws_subnet" "Oracle-SUBNET" {
    vpc_id                          = aws_vpc.Oracle-VPC.id
    availability_zone               = data.aws_availability_zones.Oracle-AD.names[0]
    cidr_block                      = var.subnet_cidr
    map_public_ip_on_launch         = var.map_public_ip_on_launch
    tags                            = {
        "Name"                      = "${var.Proyecto}-SUBNET"
    }
}
######################
# Internet Gateway
 

resource "aws_internet_gateway" "Oracle-IGW" {
    vpc_id                          = aws_vpc.Oracle-VPC.id
    tags                            = {
        "Name"                      = "${var.Proyecto}-IGW"
    }
}
######################
# Route Table
 

resource "aws_route_table" "Oracle-ROUTETABLE" {
    vpc_id                           = aws_vpc.Oracle-VPC.id
    route  {
            cidr_block               = "0.0.0.0/0"
            gateway_id               = aws_internet_gateway.Oracle-IGW.id
        }
    
    tags                             = {
        "Name"                       = "${var.Proyecto}-ROUTETABLE"
    }

}

resource "aws_route_table_association" "RouteTable-Asociacion" {
    route_table_id                   = aws_route_table.Oracle-ROUTETABLE.id
    subnet_id                        = aws_subnet.Oracle-SUBNET.id
}

######################
# Security Group
    

resource "aws_security_group" "Oracle-SG" {
    name        = "${var.Proyecto}-SG"
    vpc_id      = aws_vpc.Oracle-VPC.id
    description = "SSH ,HTTP, and HTTPS"
    egress {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "Salida por defecto permitido a todo"
            from_port        = 0
            protocol         = "-1"
            to_port          = 0
            self             = false
        }
    
    ingress     = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "Entrada HTTPS "
            from_port        = 443
            protocol         = "tcp"
            to_port          = 443
            prefix_list_ids  = null 
            ipv6_cidr_blocks = null 
            security_groups  = null 
            self             = false
            
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "Entrada ssh"
            from_port        = 22
            protocol         = "tcp"
            security_groups  = []
            to_port          = 22
             prefix_list_ids  = null 
            ipv6_cidr_blocks = null  
            security_groups  = null  
            self             = false 
        },
    ]
    tags = {
    Name = "${var.Proyecto}-RG"
  }

}

#######################
#SERVERS
#######################

resource "aws_key_pair" "Oracle-KEY" {
  key_name   = "${var.Proyecto}-KEY"
  public_key = "${file("~/Oravm2/orauser.pub")}"
  }
resource "aws_instance" "Oracle-VM" {
#   name                = "${var.Proyecto}-VM"
#   description         = "Servidor Oracle"
#   virtualization_type = "hvm"
#   root_device_name    = "/dev/xvda"
  ami                          = var.ami_id
  instance_type                = var.instance_type
  availability_zone            = data.aws_availability_zones.Oracle-AD.names[0]
  disable_api_termination      = false
  ebs_optimized                = false
  get_password_data            = false
  hibernation                  = false
  private_ip                   = var.private_ip
  associate_public_ip_address  = var.map_public_ip_on_launch
  key_name                     = aws_key_pair.Oracle-KEY.key_name
  monitoring                   = false
  secondary_private_ips        = []
  security_groups              = []
  source_dest_check            = true
  subnet_id                    = aws_subnet.Oracle-SUBNET.id
  user_data                    = filebase64(var.user_data_aws)
  vpc_security_group_ids       = [aws_security_group.Oracle-SG.id]

#   ebs_block_device {
#     device_name = "/dev/xvda"
#     volume_size = 30
#   }
   root_block_device {
        delete_on_termination = true
        encrypted             = false
        # iops                  = 100
        volume_size           = 40
    }
}

resource "aws_ebs_volume" "Oracle-VOL-ORACLE" {
  availability_zone = data.aws_availability_zones.Oracle-AD.names[0]
  size              = var.VOL-ORACLE-SIZE
}
resource "aws_ebs_volume" "Oracle-VOL-DATA" {
  availability_zone = data.aws_availability_zones.Oracle-AD.names[0]
  size              = var.VOL-DATA-SIZE
}
resource "aws_volume_attachment" "Oracle-ATTACHMENT-VOL-ORACLE" {
  device_name = "/dev/sdd"
  volume_id   = aws_ebs_volume.Oracle-VOL-ORACLE.id
  instance_id = aws_instance.Oracle-VM.id
}
resource "aws_volume_attachment" "Oracle-ATTACHMENT-VOL-DATA" {
  device_name = "/dev/sde"
  volume_id   = aws_ebs_volume.Oracle-VOL-DATA.id
  instance_id = aws_instance.Oracle-VM.id
}