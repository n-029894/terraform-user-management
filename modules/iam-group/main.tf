resource "aws_iam_group" "company-group" {
  name = var.group_name
  // We pass the username list to this module to ensure the users are created
  // before the groups.
  depends_on = [var.dependency]
}

resource "aws_iam_group_policy_attachment" "company-policy-attachment" {
  // Iterate over the list of policy ARNs.
  count      = length(var.policy_arns)
  group      = var.group_name
  policy_arn = var.policy_arns[count.index]
}

resource "aws_iam_group_membership" "company-group-membership" {
  name = "${var.group_name}-group-membership"
  // Create a list of usernames from the map of teams, skipping users if they
  // do not have an IAM username defined.
  users = flatten([for k, v in var.teams : try(v["iam"]["username"], [])])
  group = var.group_name
}
