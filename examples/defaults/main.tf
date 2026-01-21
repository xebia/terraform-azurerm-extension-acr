resource "azuread_application" "this" {
  display_name = "demo"
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application.this.client_id
}

resource "azuread_group" "acr_pull" {
  display_name     = "contrib"
  security_enabled = true
}

resource "azuread_group" "acr_push" {
  display_name     = "reader"
  security_enabled = true
}

module "defaults" {
  source = "../../src"

  service_principal_object_id = azuread_service_principal.this.object_id
  acr_pull_group_id           = azuread_group.acr_pull.object_id
  acr_push_group_id           = azuread_group.acr_push.object_id
  administrative_unit_id      = null
  group_name_suffix           = "demo"
}
