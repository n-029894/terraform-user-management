resource "googleworkspace_user" "company-name" {
  for_each = var.teams

  primary_email                 = each.value.email
  password                      = random_password.user-credentials[each.value.email].result
  hash_function                 = "crypt"
  change_password_at_next_login = true

  name {
    given_name  = each.value.given_name
    family_name = each.value.family_name
  }

  aliases = each.value.google.aliases

  organizations {
    department = each.value.team_name
    type       = "work"
  }

  // We only care about these values at creation time so we ignore ongoing
  // changes.
  lifecycle {
    ignore_changes = [
      password,
      change_password_at_next_login,
    ]
  }
}
