locals {
  // We need to prepare the data for the for_each loop below. The result is a
  // list of objects with the following format:
  //   [
  //     { role_name = "read", team_name = "sre" },
  //     { role_name = "write", team_name = "developers" },
  //   ]
  team_permissions = flatten([
    for role, teamlist in var.team_permissions : [
      for team in teamlist : {
        role_name = role
        team_name = team
      }
    ]
  ])
}

resource "github_team_repository" "company-name" {
  // This builds the terraform object ID for each team permission. The result
  // is an object with the following format:
  //   module.repo-name.github_team_repository.company-name["ROLE_NAME.TEAM_NAME"]
  // The only real purpose for this is to make it easier to recognize the
  // object ID when looking at the terraform state file.
  for_each = {
    for permission in local.team_permissions : "${permission.role_name}.${permission.team_name}" => permission
  }
  permission = each.value.role_name
  team_id    = each.value.team_name
  repository = github_repository.company-name.name
}
