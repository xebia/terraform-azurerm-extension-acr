resource "azuread_group" "spoke_acrpull_group" {
    display_name = var.acr_group_name
    owners = [var.service_principal_object_id]
    administrative_unit_ids = var.acr_group_administrative_units
    security_enabled = true
}

resource "azurerm_role_assignment" "acr_group_pull" {
  scope                = var.acr_resource_id 
  role_definition_name = "AcrPull"
  principal_id         = azuread_group.spoke_acrpull_group.object_id
}

resource "azurerm_role_assignment" "spoke_contributors_acrpull" {
  scope                = var.acr_resource_id 
  role_definition_name = "AcrPull"
  principal_id         = var.contributor_group_id 
}

resource "azurerm_role_assignment" "spoke_owners_acrpush" {
  scope                = var.acr_resource_id 
  role_definition_name = "AcrPush"
  principal_id         = var.owner_group_id
}

resource "azurerm_role_assignment" "spoke_readers_reader" {
  scope                = var.acr_resource_id 
  role_definition_name = "Reader"
  principal_id         = var.reader_group_id
}
