## Pull group
data "azuread_group" "acrpull_group" {
  object_id = var.acr_pull_group_id
}

resource "azuread_group" "spoke_acrpull_group" {
  display_name            = "${data.azuread_group.acrpull_group.display_name}-${var.group_name_suffix}"
  owners                  = [var.service_principal_object_id]
  administrative_unit_ids = [var.administrative_unit_id]
  security_enabled        = true
}

resource "azuread_group_member" "spoke_acrpull_group_member" {
  group_object_id  = data.azuread_group.acrpull_group.object_id
  member_object_id = azuread_group.spoke_acrpull_group.object_id
}

## Push group
data "azuread_group" "acrpush_group" {
  object_id = var.acr_push_group_id
}

resource "azuread_group" "spoke_acrpush_group" {
  display_name            = "${data.azuread_group.acrpush_group.display_name}-${var.group_name_suffix}"
  owners                  = [var.service_principal_object_id]
  administrative_unit_ids = [var.administrative_unit_id]
  security_enabled        = true
}

resource "azuread_group_member" "spoke_acrpush_group_member" {
  group_object_id  = data.azuread_group.acrpush_group.object_id
  member_object_id = azuread_group.spoke_acrpush_group.object_id
}
