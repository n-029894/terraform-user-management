# Background

The `teams/` directory contains yaml definitions of the teams whose user accounts we want to track in code. There are a few reasons why we would want to do that.

1. When this code is tracked in git, we have a record of when changes were made, by who, and who approved those changes to go into production. This provides an automatic audit trail if any questions arise in the future.
2. When defining the user details in a centralized manner, we can easily add and delete them from all teams, groups, policies, etc.
3. It mandates consistency throughout the organization.
4. Because the team definitions are written in yaml, we can easily add additional attributes for individual users that can be consumed by any terraform code we might add in the future.

# What happens when I add a user

The `teams/` directory is the central focus point of this project. From here we control all aspects of a user's permissions. By adding a user to the `sre.yaml` file, these definitions will automatically be created:

1. A google workspace/gmail account will be created for them in the company's domain.
2. A temporary password will be generated for that email account and stored in AWS Secrets Manager. They will be prompted to change it on first login.
3. They will be added to the `sre@email.com` Google group/mailing list.
4. An AWS IAM user account will be created for that user.
5. The AWS account password will be created and stored in AWS Secrets Manager.
6. They will be added to the AWS IAM group that is associated with their team.
7. All appropriate AWS permissions will be delegated to that user.
8. An invitation will be sent to their github user to join the company organization.
9. After accepting the invitation, they will be added to their appropriate team.
10. Access will be granted to all of the org repositories they are able to participate in.
11. Permissions to each of those repositories will be configured automatically.

# Why we use yaml

1. We can easily add additional attributes for a user without breaking code structure
2. It can be easier to read than Terraform code
3. It supports comments and json does not
4. It's easy to parse with simple tools
5. If we provide access to less technical teams for them to manage users, they will understand yaml more easily than Terraform HCL

# How these attributes get into Terraform

The [`global_vars.tf`](../global_vars.tf) file looks into this directory for all files ending with `.yaml`. It assembles that code into a single `team` object with this structure:

```
{
  sre = {
    "some_user@email.com" = {
      given_name  = "Some User"
      family_name = "Some User"
      email       = "some_user@email.com"
      team_name   = "sre"
      team_lead   = true
      iam         = {
        username = "suser"
      }
      github      = {
        username = "someuser"
      }
      google    = {
        aliases = [
          "suser",
        ]
      }
    }
    "another_user@email.com" = {
      given_name  = "Another User"
      family_name = "Another User"
      email       = "another_user@email.com"
      team_name   = "sre"
      iam         = {
        username = "otheruser"
      }
      github      = {
        username = "AnotherUser45"
      }
    }
  }
  developers = {
    "last_one@email.com" = {
      given_name  = "Last One"
      family_name = "Last One"
      email       = "last_one@email.com"
      team_name   = "developers"
      team_lead   = true
      github      = {
        username = "LastU"
      }
    }
  }
}
```

### Notes on `team_name`:

The reason we include the team name once as the top level key and as a value of `team_name` in the user object is to make it easier to parse in the code itself.

For example, using this structure, we can reference the SRE team using `local.team.sre` (the top level key).

When we pass that to a module, the only thing that the module sees is the user objects contained inside the `sre` body, not the `sre` key itself. We need to include it here so that the module knows what team we are talking about while iterating.

To access the details for each of the user objects in this body, we would use a `for_each` statement and simply ask for the value of the appropriate keys.

```
for_each  = var.team
team_name = value.each.team_name
```

### Notes on `email`:

The email address is the top level key of each user object. It is easy enough to reference it in a loop like this:

```
for_each = var.team
email    = each.key
```

This is fine and it works but, for readability, it is easier to simply inject the `email` key into the user object so it can be referenced like any other attribute associated with this user.

```
for_each = var.team
email    = each.value.email
```