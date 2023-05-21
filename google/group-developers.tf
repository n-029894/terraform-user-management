module "group-developers" {
  group_email       = "developers@email.com"
  group_name        = "Developers"
  group_description = "Company Name Developer Team"
  group_members     = local.team.developers

  source = "../modules/google-group"
}
