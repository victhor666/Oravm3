provider "azurerm" {
  features {}
}

############################
#SERVIDOR ORACLE EN AZURE    #
############################
module "azure" {
  source                    = "../modulos/azure"
  Proyecto                  = var.Proyecto
  az_location               = var.az_location  
  vnet_name                 = var.vnet_name    
  vnet_cidr                 = var.vnet_cidr    
  subnet_name               = var.subnet_name  
  subnet_cidr               = var.subnet_cidr  
  sg_name                   = var.sg_name      
  osdisk_size               = var.osdisk_size  
  disco2_size               = var.disco2_size  
  disco3_size               = var.disco3_size  
  vm_size                   = var.vm_size      
  servername                = var.servername   
  DATABASENAME              = var.DATABASENAME 
  os_publisher              = var.os_publisher 
  OS                        = var.OS   
  user_data                 = var.user_data       
}