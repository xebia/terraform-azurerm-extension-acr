resource "azuread_application" "this" {
  display_name = "demo"
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application.this.client_id
}

resource "azuread_group" "contrib" {
  display_name     = "contrib"
  security_enabled = true
}

resource "azuread_group" "reader" {
  display_name     = "reader"
  security_enabled = true
}

resource "azuread_group" "owner" {
  display_name     = "reader"
  security_enabled = true
}


resource "azurerm_resource_group" "this" {
  name     = "rg-acr-extension"
  location = "westeurope"
}

resource "azurerm_container_registry" "this" {
  name                = "acrextensiondemo"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Basic"
}

module "defaults" {
  source = "../../src"

  # Spoke group ids
  service_principal_object_id = azuread_service_principal.this.object_id
  owner_group_id              = azuread_group.owner.object_id
  contributor_group_id        = azuread_group.contrib.object_id
  reader_group_id             = azuread_group.reader.object_id

  mi_resource_group_name = azurerm_resource_group.this.name
  mi_location            = azurerm_resource_group.this.location
  mi_prefix              = "demodevweu001"

  # Acr access config
  acr_resource_id = azurerm_container_registry.this.id
  acr_group_name  = "demospoke-acrpull"
}
