resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

#################
# VNET
#################
resource "azurerm_virtual_network" "terra_vnet" {
  name                = "${var.prefix}-network"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${azurerm_resource_group.rg.location}"
  address_space       = [var.vnet_cidr]
}
#################
# SUBNET
#################
resource "azurerm_subnet" "terra_sub" {
  name                 = "terra_sub"
  virtual_network_name = "${azurerm_virtual_network.terra_vnet.name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  address_prefixes     = [var.subnet_cidr]
}

######################
# Network Security Group
######################    
resource "azurerm_network_security_group" "terra_nsg" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

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
  }
security_rule {
    name                       = "Inbound HTTP access"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["22","80","443","3389"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    description                = "RDP-HTTP-HTTPS ingress trafic" 
  }

  
tags = {
    Name = "SSH ,HTTP, and HTTPS"
  }
    timeouts {}
}

resource "azurerm_subnet_network_security_group_association" "nsg_sub" {
  subnet_id                 = azurerm_subnet.terra_sub.id
  network_security_group_id = azurerm_network_security_group.terra_nsg.id
}

resource "azurerm_network_interface" "Terranic" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "terra_subconfiguration"
    subnet_id                     = azurerm_subnet.terra_sub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.terrapubip.id
  }
}

  resource "azurerm_public_ip" "terrapubip" {
  name                = "TerraPublicIp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"

  tags = {
    app = "Static WebSite Ip "
  }
}

resource "azurerm_network_interface_security_group_association" "terra_assos_pubip_nsg" {
  network_interface_id      = azurerm_network_interface.Terranic.id
  network_security_group_id = azurerm_network_security_group.terra_nsg.id
}

resource "azurerm_linux_virtual_machine" "terravm" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.Terranic.id]
  size               = var.vm_size
  computer_name  = "terrahost"
  admin_username = var.os_publisher[var.OS].admin
  disable_password_authentication = true
  provision_vm_agent = true
  custom_data    = base64encode ("${file(var.user_data)}")
        #custom_data    = "${path.root}/scripts/middleware_disk.sh"

admin_ssh_key {
    username = var.os_publisher[var.OS].admin
    public_key = file("~/id_rsa_az.pub")
  }
######################
# IMAGE
######################  
 source_image_reference {
    publisher = var.os_publisher[var.OS].publisher
    offer     = var.os_publisher[var.OS].offer
    sku       = var.os_publisher[var.OS].sku
    version   = "latest"
  }
 
 


  # Uncomment this line to delete the OS disk automatically when deleting the VM
  #delete_os_disk_on_termination = true
  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true
  
  

######################
# VOLUME
######################  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.osdisk_size
  }
 
  tags = {
    environment = "demo"
  }
}
