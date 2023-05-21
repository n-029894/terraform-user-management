module "users-company" {

  // We use merge() when specifying multiple teams. This will create a flat map
  // of all users. Creating a flat map makes it easier to iterate over the user
  // objects in the module.
  teams = merge(
    // Only create user accounts for teams who should have access
    local.team.sre,
    local.team.developers,
  )

  source = "../modules/google-workspace-users"
}
