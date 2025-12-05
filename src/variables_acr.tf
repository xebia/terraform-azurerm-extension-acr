variable "acr_resource_id" {
  description = "The resource ID of the container registry to grant access to"
  type        = string
}

variable "acr_group_name" {
  description = "The name of the group to create"
  type        = string
}

variable "acr_group_administrative_units" {
  description = "The list of administrative unit IDs the spoke acrpull group should belong to"
  type        = list(string)
  default     = []
}
