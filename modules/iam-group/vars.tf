variable "group_name" {
  description = "Name of the group"
  type        = string
}

variable "policy_arns" {
  description = "List of policy ARNs to attach to the group"
  type        = list(any)
  default     = []
}

variable "teams" {
  description = "Teams object"
}

variable "dependency" {
  description = "Dependency on other resources"
  type        = list(any)
  default     = []
}
