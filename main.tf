terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.91.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "RCreation" {
  name     = "RCreation"
  location = "West Europe"
}

resource "azurerm_network_security_group" "snet" {
  name                = "snet"
  location            = azurerm_resource_group.RCreation.location
  resource_group_name = azurerm_resource_group.RCreation.name
}

resource "azurerm_virtual_network" "example" {
  name                = "VNET"
  location            = azurerm_resource_group.RCreation.location
  resource_group_name = azurerm_resource_group.RCreation.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.snet.id
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_security_group" "SGRoup" {
  name                = "SGRoup"
  location            = azurerm_resource_group.RCreation.location
  resource_group_name = azurerm_resource_group.RCreation.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "usos" {
  name                     = "kfjsdkfhiehlskd"
  resource_group_name      = azurerm_resource_group.RCreation.name
  location                 = azurerm_resource_group.RCreation.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "example" {
  name               = "example"
  storage_account_id = azurerm_storage_account.usos.id

  properties = {
    hello = "aGVsbG8="
  }
}
