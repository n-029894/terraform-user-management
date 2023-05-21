resource "googleworkspace_group" "company-name" {
  email       = var.group_email
  name        = var.group_name
  description = var.group_description
  aliases     = var.group_aliases
}

resource "googleworkspace_group_member" "company-name" {
  // Iterate over the user maps
  for_each = var.teams
  // The ID of the group created above
  group_id = googleworkspace_group.company-name.id
  email    = each.value.email

  // If team_lead == true, then role = MANAGER, else role = MEMBER
  role = each.value.team_lead == true ? "MANAGER" : "MEMBER"
}
