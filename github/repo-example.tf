module "repo-infrastructure" {
  repository_name = "Infrastructure"
  visibility      = "private"

  // Teams and users require different terraform resources be created. We split
  // them here mostly for readability but also because either can be omitted
  // depending on your use case.
  team_permissions = {
    read = [
      module.team-developers.team_id,
    ]

    triage = [
    ]

    write = [
    ]

    maintain = [
      module.team-sre.team_id,
    ]

    admin = [
    ]
  }

  user_permissions = {
    read = [
    ]

    triage = [
    ]

    write = [
    ]

    maintain = [
    ]

    admin = [
      // Users can be defined using either the terraform resource or a string
      // containing their github username.
      module.team-sre.github_team_membership.company-admins["some_user@email.com"].username,
      "LastU",
    ]
  }

  source = "../modules/github-repository"
}
