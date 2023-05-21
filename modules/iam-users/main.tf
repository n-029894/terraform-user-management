resource "aws_iam_user" "users" {
  // Only create user accounts if a username is defined in the team file
  for_each = { for k, v in var.teams : k => v if try(v.iam.username, null) != null }
  name     = each.value.iam.username

  tags = {
    // The email and team_name values were dynamically inserted into the user
    // map in the global_vars.tf file. This is an example of how it becomes
    // easier to access those values.
    email = each.value.email
    team  = each.value.team_name
  }
}

output "iam_users_list" {
  // This output isn't used for anything other than establishing a dependency
  // with an IAM group definition.
  value = [aws_iam_user.users.*]
}
