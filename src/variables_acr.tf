variable "spoke_name" {
  description = "The name of the spoke, used as suffix for the spoke-specific ACR sub-groups."
  type        = string
}

variable "acr_pull_group_object_id" {
  description = "The object ID of the main AcrPull group in the shared ACR service."
  type        = string
}

variable "acr_push_group_object_id" {
  description = "The object ID of the main AcrPush group in the shared ACR service."
  type        = string
}

variable "administrative_unit_id" {
  description = "The ID of the administrative unit to place spoke sub-groups in."
  type        = string
  default     = null
}
