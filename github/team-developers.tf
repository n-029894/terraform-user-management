module "team-developers" {
  team_name    = "team-developers"
  team_members = local.team.developers

  source = "../modules/github-team"
}
