resource "azuread_application" "this" {
  display_name = "demo"
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application.this.client_id
}

resource "azuread_group" "acr_pull_main" {
  display_name     = "acr-pull-main"
  security_enabled = true
}

resource "azuread_group" "acr_push_main" {
  display_name     = "acr-push-main"
  security_enabled = true
}

resource "azurerm_resource_group" "this" {
  name     = "rg-acr-extension"
  location = "westeurope"
}

module "defaults" {
  source = "../../src"

  service_principal_object_id = azuread_service_principal.this.object_id
  mi_resource_group_name      = azurerm_resource_group.this.name
  mi_location                 = azurerm_resource_group.this.location
  mi_prefix                   = "demodevweu001"

  spoke_name               = "demo"
  acr_pull_group_object_id = azuread_group.acr_pull_main.object_id
  acr_push_group_object_id = azuread_group.acr_push_main.object_id
}
