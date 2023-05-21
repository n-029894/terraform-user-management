resource "random_password" "user-credentials" {
  // We use for_each to create a password for each user and to be able to
  // access it's value with this terraform object ID:
  //   random_password.user-credentials["some_user@email.com"].result
  for_each = var.teams
  length   = 16
  special  = false

  // We only care about these values at creation time. We ignore ongoing
  // changes.
  lifecycle {
    ignore_changes = [
      length,
      special,
    ]
  }
}

// The following two resources are used to store the user credentials in AWS
// Secrets Manager. If another secret storage provider is available, you can
// still use this method by accessing the above randomly generated password
// with the following terraform object ID format:
//   random_password.user-credentials["some_user@email.com"].result
resource "aws_secretsmanager_secret" "user-credentials" {
  for_each = var.teams
  // Occasionally, provisioning new user accounts is done by an IT or HR team.
  // By programmatically prefixing the secret with "google_user_credentials_"
  // it allows us to create an IAM policy which grants access to only the
  // secrets containing this prefix to the non-technical teams doing the
  // account creations.
  name = "google_user_credentials_${each.value.email}"
}

resource "aws_secretsmanager_secret_version" "user-credentials" {
  for_each  = var.teams
  secret_id = aws_secretsmanager_secret.user-credentials[each.value.email].id
  secret_string = jsonencode({
    email    = each.value.email
    password = random_password.user-credentials[each.value.email].result
  })
}
