variable "mi_prefix" {
  description = "The name prefix for the managed identities and spoke resources."
  type        = string
}

variable "service_principal_object_id" {
  description = "The ID of the service principal of the spoke."
  type        = string
}

variable "mi_resource_group_name" {
  description = "The name of the resource group where managed identities will be created."
  type        = string
}

variable "mi_location" {
  description = "The Azure location of the managed identities resource group."
  type        = string
}
