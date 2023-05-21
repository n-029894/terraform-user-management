// This creates permissions for individual users on a repository. The preferred
// way to grant access is via teams, but sometimes you need to grant access to
// a single user. This accounts for those exceptions.
locals {
  // We need to prepare the data for the for_each loop below. The result is a
  // list of objects with the following format:
  //   [
  //     { role_name = "read", user_name = "user1" },
  //     { role_name = "write", user_name = "user2" },
  //   ]
  user_permissions = flatten([
    for role, userlist in var.user_permissions : [
      for user in userlist : {
        role_name = role
        user_name = user
      }
    ]
  ])
}

resource "github_repository_collaborator" "company-name" {
  // This builds the terraform object ID for each user permission. The result
  // is an object with the following format:
  //   module.repo-name.github_repository_collaborator.company-name["ROLE_NAME.USER_NAME"]
  // The only real purpose for this is to make it easier to recognize the
  // object ID when looking at the terraform state file.
  for_each = {
    for permission in local.user_permissions : "${permission.role_name}.${permission.user_name}" => permission
  }
  permission = each.value.role_name
  username   = each.value.user_name
  repository = github_repository.company-name.name
}
