module "group-sre" {
  group_email       = "sre@email.com"
  group_name        = "SRE"
  group_description = "Company Name SRE Team"
  group_members     = local.team.sre

  source = "../modules/google-group"
}
