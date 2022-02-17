# Azure account region and authentication
variable "Proyecto" {
  description = "Prefijo para todo"
}

variable "az_location" {
}
# INFO VPC
variable "vnet_name" {
}

variable "vnet_cidr" {
  default = "192.168.0.0/16"
}

# INFO SUBNET
variable "subnet_name" {
  default = "OracleSubet1"
}

variable "subnet_cidr" {
  default = "192.168.10.0/24"
}
variable "sg_name" {
  default = "oracle_sg"
}

# VARIABLES SIMPLIFICADAS PARA LA INSTANCIA

variable "osdisk_size" {
  default = "30"
}
variable "disco2_size" {
  default = "30"
}
variable "disco3_size" {
  default = "10"
}
variable "vm_size" {
  #  Standard_B2ms para test y pruebas. Usar máquinas con al menos 8GB de memoria y >15GB de disco temporal
  default = "Standard_B4ms"
}
variable "servername"{
  default = "OraVM"
}
variable "DATABASENAME" {
  default = "ORCLBBDD1"
}

variable "os_publisher" {

}
variable "OS" {
  description = "El sistema operativo elegido es"

}

# VNIC INFO
variable "private_ip" {

}

# BOOT INFO
# user data
variable "user_data" {

}

# EBS
#
variable "network_interface" {
  description = "Personalizar interface en el arranque"
  type        = list(map(string))
  default     = []
}