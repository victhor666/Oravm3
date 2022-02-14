##############################
##### VARIABLES GENERALES
##############################

# Aws account region and autehntication 
#variable "aws_access_key" {}
#variable "aws_secret_key" {}
variable "Proyecto" {
    description= "Nombre del proyecto. Será el prefijo de los nombres de los objetos que se creen y de las tags. Ejemplo: Oracle, Oratest,Oracle-test"
    type=string
}

variable "Location" {
    type=string
}

##############################
#####VARIABLES NETWORK
##############################
# VPC 
    
    variable "vpc_cidr" {
      type=string
    }

# SUBNET 

    variable "subnet_cidr"{
      type=string
      } 
    variable "map_public_ip_on_launch" { 
      description = "Se le asigna una ip publica al desplegar o no. "
    }  
##############################
#####VARIABLES SERVER
##############################

      variable "preserve_boot_volume" {
        default = false
      }
      variable "boot_volume_size_in_gbs" {
        type = number
      }
      variable "instance_type" {
        type= string
      }
      variable "ami_id" {
        description = "Ami de oracle linux 7.9"
        default   = "ami-0484afc52074f4f84"
     }

# # VNIC INFO
#         variable "private_ip" {
#         default = "192.168.10.51"
#       }
      
# BOOT INFO      
  # user data
      variable "user_data_aws" {
        default = "~/Oravm3/modulos/aws/user_data_aws.txt"
      }     
      variable "block_storage_size_in_gbs" {
        description = "particion del sistema"
        type=number
      }
 # EBS 
      variable "VOL-ORACLE-SIZE" {
      type        = number
      description = "tamano particion oracle"
      }
      variable "VOL-DATA-SIZE" {
      type        = number
      description = "Tamano particion datos"
      }
      variable "ebs_volume_enabled" {
      type        = bool
      default     = true
      description = "Para controlar la creacion del volumen"
      }     
      variable "ebs_volume_type" {
      type        = string
      default     = "gp2"
      description = "Tpo de volumen, puede ser  standard, gp2 or io1."
      }
      variable "ebs_iops" {
      type        = number
      default     = 0
      description = "Solo tiene sentido si el volumen es io1."
      }