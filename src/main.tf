data "azuread_client_config" "current" {}

resource "azuread_group" "acr_pull" {
  display_name     = "acr-pull-${var.spoke_name}"
  description      = "Security group for AcrPull access for spoke ${var.spoke_name} on the shared Azure Container Registry"
  security_enabled = true
  owners = [
    data.azuread_client_config.current.object_id,
    var.service_principal_object_id,
  ]

  administrative_unit_ids = var.administrative_unit_id != null ? [var.administrative_unit_id] : null

  lifecycle {
    ignore_changes = [members]
  }
}

resource "azuread_group" "acr_push" {
  display_name     = "acr-push-${var.spoke_name}"
  description      = "Security group for AcrPush access for spoke ${var.spoke_name} on the shared Azure Container Registry"
  security_enabled = true
  owners = [
    data.azuread_client_config.current.object_id,
    var.service_principal_object_id,
  ]

  administrative_unit_ids = var.administrative_unit_id != null ? [var.administrative_unit_id] : null

  lifecycle {
    ignore_changes = [members]
  }
}

resource "azuread_group_member" "acr_pull_sub_to_main" {
  group_object_id  = var.acr_pull_group_object_id
  member_object_id = azuread_group.acr_pull.object_id
}

resource "azuread_group_member" "acr_push_sub_to_main" {
  group_object_id  = var.acr_push_group_object_id
  member_object_id = azuread_group.acr_push.object_id
}

resource "azurerm_user_assigned_identity" "spoke_pull_mi" {
  name                = "${var.mi_prefix}-acrpull-mi"
  resource_group_name = var.mi_resource_group_name
  location            = var.mi_location
}

resource "azurerm_user_assigned_identity" "spoke_push_mi" {
  name                = "${var.mi_prefix}-acrpush-mi"
  resource_group_name = var.mi_resource_group_name
  location            = var.mi_location
}

resource "time_sleep" "wait_for_mi_propagation" {
  depends_on = [
    azurerm_user_assigned_identity.spoke_pull_mi,
    azurerm_user_assigned_identity.spoke_push_mi,
  ]

  create_duration = "30s"
}

resource "azuread_group_member" "pull_mi_to_acr_pull" {
  depends_on       = [time_sleep.wait_for_mi_propagation]
  group_object_id  = azuread_group.acr_pull.object_id
  member_object_id = azurerm_user_assigned_identity.spoke_pull_mi.principal_id
}

resource "azuread_group_member" "push_mi_to_acr_push" {
  depends_on       = [time_sleep.wait_for_mi_propagation]
  group_object_id  = azuread_group.acr_push.object_id
  member_object_id = azurerm_user_assigned_identity.spoke_push_mi.principal_id
}
