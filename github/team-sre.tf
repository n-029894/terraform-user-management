module "team-sre" {
  team_name    = "team-sre"
  team_members = local.team.sre

  source = "../modules/github-team"
}
