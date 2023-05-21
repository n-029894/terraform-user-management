variable "group_members" {
  description = "A map of users to be created"
}

variable "group_email" {
  description = "Address of the group being created"
  type        = string
}

variable "group_name" {
  description = "The display name of the group"
  type        = string
  default     = null
}

variable "group_description" {
  description = "A description of the group"
  type        = string
  default     = null
}

variable "group_aliases" {
  description = "A list of aliases for the group"
  type        = list(string)
  default     = []
}
