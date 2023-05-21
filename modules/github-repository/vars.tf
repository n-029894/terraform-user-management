variable "repository_name" {
  type = string
}

variable "visibility" {
  type    = string
  default = "private"
}

variable "has_issues" {
  type    = bool
  default = true
}

variable "has_discussions" {
  type    = bool
  default = true
}

variable "has_wiki" {
  type    = bool
  default = true
}

variable "delete_branch_on_merge" {
  type    = bool
  default = true
}

variable "auto_init" {
  type    = bool
  default = true
}

variable "vulnerability_alerts" {
  type    = bool
  default = true
}

variable "user_permissions" {
  description = "A map of user permissions."
  default     = {}
}

variable "team_permissions" {
  description = "A map of team permissions."
  default     = {}
}
