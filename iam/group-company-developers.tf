module "group-developers" {
  group_name = "CompanyDevelopers"

  // We use merge() when specifying multiple teams. This will create a flat map
  // of all users. Creating a flat map makes it easier to iterate over the user
  // objects in the module.
  teams = merge(
    local.team.developers,
  )

  policy_arns = [
    aws_iam_policy.company-developers.arn,
  ]

  // Don't attempt to create this group until the users have been created
  dependency = module.users-company.iam_users_list
  source     = "../modules/iam-group"
}
