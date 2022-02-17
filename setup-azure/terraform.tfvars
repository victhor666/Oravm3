Proyecto = "Oracle"
az_location = "eastus"
vnet_name="OracleVnet"
vnet_cidr="192.168.0.0/16"
subnet_name= "OracleSubet1"
subnet_cidr ="192.168.10.0/24"
sg_name = "oracle_sg"
osdisk_size = 30
disco2_size = 30
disco3_size =10
vm_size = "Standard_B2ms"
servername= "OraVM"
DATABASENAME="ORCLBBDD1"
os_publisher= {
    OL7 = {
      publisher = "Oracle"
      offer     = "Oracle-Linux"
      sku       = "79-gen2"
    }
  }
OS = "OL7"
user_data="~/Oravm3/setup-azure/user_data_azure.txt"
