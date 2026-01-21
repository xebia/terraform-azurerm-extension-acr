variable "service_principal_object_id" {
  description = "The ID of the service principal of the spoke. This service principal will own the spoke specific ACR groups."
  type        = string
}

variable "group_name_suffix" {
  description = "The suffix to use for group names. The final group name will be <original_group_name>-<group_name_suffix>."
  type        = string
}

variable "administrative_unit_id" {
  description = "The administrative unit ID where the ACR groups will be created."
  type        = string
}
