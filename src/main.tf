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

# Managed Identities for Pull, Push, Reader
resource "azurerm_user_assigned_identity" "spoke_pull_mi" {
  name                = "${var.spoke_name}-acrpull-mi"
  resource_group_name = var.spoke_resource_group_name
  location            = var.spoke_location
}

resource "azurerm_user_assigned_identity" "spoke_push_mi" {
  name                = "${var.spoke_name}-acrpush-mi"
  resource_group_name = var.spoke_resource_group_name
  location            = var.spoke_location
}

resource "azurerm_user_assigned_identity" "spoke_reader_mi" {
  name                = "${var.spoke_name}-acrreader-mi"
  resource_group_name = var.spoke_resource_group_name
  location            = var.spoke_location
}

# Add Managed Identities to correct AD group
resource "azuread_group_member" "pull_mi_member" {
  group_object_id = azuread_group.spoke_acrpull_group.object_id
  member_object_id = azurerm_user_assigned_identity.spoke_pull_mi.principal_id
}

resource "azuread_group_member" "push_mi_member" {
  group_object_id = var.owner_group_id
  member_object_id = azurerm_user_assigned_identity.spoke_push_mi.principal_id
}

resource "azuread_group_member" "reader_mi_member" {
  group_object_id = var.reader_group_id
  member_object_id = azurerm_user_assigned_identity.spoke_reader_mi.principal_id
}

# Assign ACR roles to Managed Identities
resource "azurerm_role_assignment" "pull_mi_acrpull" {
  scope                = var.acr_resource_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.spoke_pull_mi.principal_id
}

resource "azurerm_role_assignment" "push_mi_acrpush" {
  scope                = var.acr_resource_id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_user_assigned_identity.spoke_push_mi.principal_id
}

resource "azurerm_role_assignment" "reader_mi_reader" {
  scope                = var.acr_resource_id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.spoke_reader_mi.principal_id
}
