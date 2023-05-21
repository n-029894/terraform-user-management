module "users-contractors" {
  // We use merge() when specifying multiple teams. This will create a flat map
  // of all users. Creating a flat map makes it easier to iterate over the user
  // objects in the module.
  teams = merge(
    // Easily separate contractors from employees
    local.team.contractors,
  )

  source = "../modules/iam-users"
}
