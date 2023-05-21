locals {
  // Specify teams which are granted admin access to the org. The SRE team is
  // designated as github admins in this instance.
  // The fileset() OR matching pattern is:
  //   {team_1,team_2,...,team_n}.yaml
  admin_groups = fileset(path.root, "../../teams/{sre}.yaml")
  // Create a list of admin usernames
  admin_users = flatten([
    // Iterate over each file in the admin_groups list
    for f in local.admin_groups : [
      // Iterate over each user in the file
      for u in yamldecode(file(f)) : [
        u["github"]["username"],
      ]
    ]
  ])
}

resource "github_team" "company-name" {
  name    = var.team_name
  privacy = "closed"
}

// When a user is added to the org, an invitation is sent to the user's email.
// The user account must already exist.
resource "github_membership" "company-name" {
  for_each = var.team_members
  username = each.value.github.username
  // Set to admin if the username is in the admin_users list defined above.
  // Otherwise, set to member.
  role = contains(local.admin_users, each.value.github.username) ? "admin" : "member"
}

// The following two resources adds the users to thier appropriate team
resource "github_team_membership" "company-admins" {
  // Iterate over all users in the team_members map but only include those
  // whose names are in the admin_users list
  for_each = {
    for k, v in var.team_members : k => v if contains(local.admin_users, v.github.username)
  }
  team_id  = github_team.company-name.id
  username = each.value.github.username

  // Roles in a team have no effect on org admins so we ignore
  lifecycle {
    ignore_changes = [
      role,
    ]
  }
}

// We track role changes for all other users
resource "github_team_membership" "company-non-admins" {
  // Iterate over all users in the team_members map but exclude those whose
  // names are not in the admin_users list
  for_each = {
    for k, v in var.team_members : k => v if !contains(local.admin_users, v.github.username)
  }
  team_id  = github_team.company-name.id
  username = each.value.github.username
  // If team_lead is set to true in the teams file, grant the user maintainer
  // permissions over the group.
  role = try(each.value.team_lead, false) ? "maintainer" : "member"
}

// This output is used to grant access to repositories.
output "team_id" {
  value = github_team.company-name.id
}
