#################
# GRUPO DE RECURSOS
#################
resource "azurerm_resource_group" "Rg" {
  name     = "${var.Proyecto}-rg"
  location = "${var.az_location}"
}

#################
# VNET
#################
resource "azurerm_virtual_network" "Oracle_Vnet" {
  name                = "${var.prefix}-network"
  resource_group_name = azurerm_resource_group.Rg.name
  location            = azurerm_resource_group.Rg.location
  address_space       = [var.vnet_cidr]
}
#################
# SUBREDES
#################
# aws_subnet.terra_sub:
resource "azurerm_subnet" "Oracle_Subnet" {
  name                 = "internal"
  virtual_network_name = azurerm_virtual_network.Oracle_Vnet.name
  resource_group_name  = azurerm_resource_group.Rg.name
  address_prefixes     = [var.subnet_cidr]
}

######################
# GRUPOS DE SEGURIDAD
######################

resource "azurerm_network_security_group" "Oracle_Nsg" {
  name                = "${var.prefix}-Nsg"
  location            = azurerm_resource_group.Rg.location
  resource_group_name = azurerm_resource_group.Rg.name

  security_rule {
    name                       = "Egress"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    description                = "Salida a internet sin restricciones. Debe ser modificado mas adelante"
  }
  security_rule {
    name                       = "Inbound HTTP-SSH access"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "80", "443"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    description                = "SSH-HTTP-HTTPS entradas estandar de gestion"
  }


  tags = {
    Name = "SSH ,HTTP, and HTTPS"
  }
  timeouts {}
}

resource "azurerm_subnet_network_security_group_association" "nsg_sub" {
  subnet_id                 = azurerm_subnet.Oracle_Subnet.id
  network_security_group_id = azurerm_network_security_group.Oracle_Nsg.id
}

resource "azurerm_network_interface" "OraNic" {
  name                = "${var.Proyecto}-nic"
  location            = azurerm_resource_group.Rg.location
  resource_group_name = azurerm_resource_group.Rg.name

  ip_configuration {
    name                          = "Configuracion_ip"
    subnet_id                     = azurerm_subnet.Oracle_Subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.IpPublica.id
  }
}
resource "azurerm_public_ip" "IpPublica" {
  name                = "IP-Publica"
  resource_group_name = azurerm_resource_group.Rg.name
  location            = azurerm_resource_group.Rg.location
  allocation_method   = "Dynamic"

  tags = {
    app = "IP-estatica "
  }
}

resource "azurerm_network_interface_security_group_association" "AsocSG" {
  network_interface_id      = azurerm_network_interface.OraNic.id
  network_security_group_id = azurerm_network_security_group.Oracle_Nsg.id
}
resource "azurerm_linux_virtual_machine" "OraVm" {
  name                            = "${var.Proyecto}-vm"
  location                        = azurerm_resource_group.Rg.location
  resource_group_name             = azurerm_resource_group.Rg.name
  network_interface_ids           = [azurerm_network_interface.OraNic.id]
  size                            = var.vm_size
  computer_name                   = var.servername
  admin_username                  = "azureuser"
  disable_password_authentication = true
  provision_vm_agent              = true
  custom_data                     = base64encode("${file(var.user_data)}")


  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/Oravm3/orauser.pub")
  }
  ######################
  # IMAGEN
  ######################
  source_image_reference {
    publisher = var.os_publisher[var.OS].publisher
    offer     = var.os_publisher[var.OS].offer
    sku       = var.os_publisher[var.OS].sku
    version   = "latest"
  }
 ######################
  # VOLUMEN
  ######################
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.osdisk_size
  }

  tags = {
    environment = "Orademo"
  }
      provisioner "local-exec" {
    command = "sed -i \"s/ORCLBBDD1/${var.DATABASENAME}/g\" $(pwd)/Oravm3/userdata.txt"
    interpreter = ["/bin/bash", "-c"]
  }
}
###############################
## Agregamos un disco adicional
###############################
resource "azurerm_managed_disk" "disco2" {
  name                            = "${var.Proyecto}-vm-disco2"
  location                        = azurerm_resource_group.Rg.location
  resource_group_name             = azurerm_resource_group.Rg.name
  storage_account_type            = "Standard_LRS"
  create_option                   = "Empty"
  disk_size_gb                    = var.disco2_size
}
resource "azurerm_managed_disk" "disco3" {
  name                            = "${var.Proyecto}-vm-disco3"
  location                        = azurerm_resource_group.Rg.location
  resource_group_name             = azurerm_resource_group.Rg.name
  storage_account_type            = "Standard_LRS"
  create_option                   = "Empty"
  disk_size_gb                    = var.disco3_size
}

resource "null_resource" "previous" {}

resource "time_sleep" "wait_90_seconds" {
  depends_on = [null_resource.previous]

  create_duration = "90s"
}

resource "azurerm_virtual_machine_data_disk_attachment" "disco2" {
  managed_disk_id    = azurerm_managed_disk.disco2.id
  virtual_machine_id = azurerm_linux_virtual_machine.OraVm.id
  lun                = "1"
  caching            = "ReadWrite"
depends_on = [null_resource.previous]
}


resource "azurerm_virtual_machine_data_disk_attachment" "disco3" {
  managed_disk_id    = azurerm_managed_disk.disco3.id
  virtual_machine_id = azurerm_linux_virtual_machine.OraVm.id
  lun                = "2"
  caching            = "ReadWrite"
  depends_on =[azurerm_virtual_machine_data_disk_attachment.disco2]
}