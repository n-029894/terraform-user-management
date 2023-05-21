module "group-engineering" {
  group_email       = "engineering@email.com"
  group_name        = "Engineering"
  group_description = "Company Name Engineering Department"
  // Multiple teams can be combined easily with merge() to account for
  // department-wide groups.
  group_members = merge(
    local.team.developers,
    local.team.sre,
  )

  source = "../modules/google-group"
}
